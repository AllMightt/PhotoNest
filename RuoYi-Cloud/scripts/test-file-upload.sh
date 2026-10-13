#!/usr/bin/env zsh
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
FILE_SERVICE_URL="${FILE_SERVICE_URL:-http://[::1]:9300}"
MINIO_URL="${MINIO_URL:-http://127.0.0.1:9000}"
MINIO_ACCESS_KEY="${MINIO_ACCESS_KEY:-minioadmin}"
MINIO_SECRET_KEY="${MINIO_SECRET_KEY:-minioadmin}"
MINIO_BUCKET="${MINIO_BUCKET:-photonest-test}"
TEST_IMAGE="${TEST_IMAGE:-${ROOT_DIR}/../RuoYi-Cloud-Vue3/src/assets/logo/logo.png}"
JAVA_HOME="${PHOTONEST_JAVA_HOME:-/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home}"
MAVEN_REPO="${MAVEN_REPO:-${HOME}/.m2/repository}"

log() {
  printf '\n[%s] %s\n' "$(date '+%H:%M:%S')" "$*"
}

fail() {
  printf 'FAIL: %s\n' "$*" >&2
  exit 1
}

json_value() {
  node -e '
const data = JSON.parse(process.argv[1]);
const expr = process.argv[2].split(".");
let cur = data;
for (const key of expr) cur = cur == null ? undefined : cur[key];
if (cur == null) process.exit(2);
console.log(String(cur));
' "$1" "$2"
}

local_curl() {
  local args=()
  for arg in "$@"; do
    args+=("$(printf '%q' "${arg}")")
  done
  zsh -lc "curl -g --noproxy localhost,127.0.0.1,::1 ${args[*]}"
}

loopback_url() {
  printf '%s' "$1" | sed 's#http://127\.0\.0\.1:#http://[::1]:#'
}

[[ -f "${TEST_IMAGE}" ]] || fail "测试图片不存在：${TEST_IMAGE}"

cd "${ROOT_DIR}"

log "检查当前 ruoyi-file 本地上传接口"
local_curl -fsS "${FILE_SERVICE_URL}/actuator/health" >/dev/null \
  || fail "ruoyi-file 未启动或不可访问：${FILE_SERVICE_URL}"

local_resp="$(local_curl -fsS -F "file=@${TEST_IMAGE}" "${FILE_SERVICE_URL}/upload")" \
  || fail "本地上传接口请求失败"
local_code="$(json_value "${local_resp}" "code")"
[[ "${local_code}" == "200" ]] || fail "本地上传接口返回异常：${local_resp}"
local_url="$(json_value "${local_resp}" "data.url")"
local_check_url="$(loopback_url "${local_url}")"
local_curl -fsS -I "${local_check_url}" >/dev/null \
  || fail "本地上传文件 URL 不可访问：${local_url}"
printf 'OK: 本地上传成功：%s\n' "${local_url}"

log "检查 MinIO 健康状态"
local_curl -fsS "${MINIO_URL}/minio/health/live" >/dev/null \
  || fail "MinIO 未启动或不可访问：${MINIO_URL}"

log "编译 ruoyi-file 并准备验证类"
"${JAVA_HOME}/bin/java" -version >/dev/null
JAVA_HOME="${JAVA_HOME}" mvn -q -Dmaven.repo.local="${MAVEN_REPO}" -pl ruoyi-modules/ruoyi-file -am compile -DskipTests
cp_file="$(mktemp)"
JAVA_HOME="${JAVA_HOME}" mvn -q -Dmaven.repo.local="${MAVEN_REPO}" -pl ruoyi-modules/ruoyi-file dependency:build-classpath -Dmdep.outputFile="${cp_file}"

verify_dir="$(mktemp -d)"
verify_java="${verify_dir}/VerifyMinioUpload.java"
cat > "${verify_java}" <<'JAVA'
import com.ruoyi.file.config.MinioConfig;
import com.ruoyi.file.service.MinioSysFileServiceImpl;
import io.minio.MinioClient;
import io.minio.StatObjectArgs;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Field;
import java.nio.file.Files;
import java.nio.file.Path;
import org.springframework.web.multipart.MultipartFile;

public class VerifyMinioUpload {
    public static void main(String[] args) throws Exception {
        String minioUrl = args[0];
        String accessKey = args[1];
        String secretKey = args[2];
        String bucketName = args[3];
        Path image = Path.of(args[4]);

        MinioConfig config = new MinioConfig();
        config.setUrl(minioUrl);
        config.setAccessKey(accessKey);
        config.setSecretKey(secretKey);
        config.setBucketName(bucketName);
        config.setPublicRead(true);

        MinioSysFileServiceImpl service = new MinioSysFileServiceImpl();
        setField(service, "minioConfig", config);
        setField(service, "client", config.getMinioClient());

        MultipartFile file = new BytesMultipartFile("file", "photonest-minio-verify.png", "image/png", Files.readAllBytes(image));
        String url = service.uploadFile(file);
        String objectName = url.substring((minioUrl + "/" + bucketName + "/").length());

        MinioClient client = config.getMinioClient();
        client.statObject(StatObjectArgs.builder().bucket(bucketName).object(objectName).build());
        System.out.println(url);
    }

    private static void setField(Object target, String name, Object value) throws Exception {
        Field field = target.getClass().getDeclaredField(name);
        field.setAccessible(true);
        field.set(target, value);
    }

    private static class BytesMultipartFile implements MultipartFile {
        private final String name;
        private final String originalFilename;
        private final String contentType;
        private final byte[] bytes;

        BytesMultipartFile(String name, String originalFilename, String contentType, byte[] bytes) {
            this.name = name;
            this.originalFilename = originalFilename;
            this.contentType = contentType;
            this.bytes = bytes;
        }

        public String getName() { return name; }
        public String getOriginalFilename() { return originalFilename; }
        public String getContentType() { return contentType; }
        public boolean isEmpty() { return bytes.length == 0; }
        public long getSize() { return bytes.length; }
        public byte[] getBytes() { return bytes; }
        public InputStream getInputStream() { return new ByteArrayInputStream(bytes); }
        public void transferTo(File dest) throws IOException, IllegalStateException { Files.write(dest.toPath(), bytes); }
    }
}
JAVA

module_cp="${ROOT_DIR}/ruoyi-modules/ruoyi-file/target/classes:${ROOT_DIR}/ruoyi-api/ruoyi-api-system/target/classes:${ROOT_DIR}/ruoyi-common/ruoyi-common-core/target/classes:$(cat "${cp_file}")"
"${JAVA_HOME}/bin/javac" -cp "${module_cp}" "${verify_java}"

log "调用 MinIO 文件服务实现上传"
minio_url="$("${JAVA_HOME}/bin/java" -cp "${verify_dir}:${module_cp}" VerifyMinioUpload "${MINIO_URL}" "${MINIO_ACCESS_KEY}" "${MINIO_SECRET_KEY}" "${MINIO_BUCKET}" "${TEST_IMAGE}")"
local_curl -fsS -I "${minio_url}" >/dev/null \
  || fail "MinIO 上传文件 URL 不可公开访问：${minio_url}"

printf 'OK: MinIO 上传成功：%s\n' "${minio_url}"
printf '\n文件上传验证全部通过。\n'
