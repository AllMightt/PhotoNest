#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BASE_URL="${BASE_URL:-http://localhost:8080}"
MYSQL_CONTAINER="${MYSQL_CONTAINER:-ruoyi-mysql}"
REDIS_CONTAINER="${REDIS_CONTAINER:-ruoyi-redis}"
MYSQL_PASSWORD="${MYSQL_PASSWORD:-password}"
MYSQL_DATABASE="${MYSQL_DATABASE:-ry-cloud}"

ADMIN_USERNAME="${ADMIN_USERNAME:-admin}"
ADMIN_PASSWORD="${ADMIN_PASSWORD:-admin123}"
PHOTO_A_USERNAME="${PHOTO_A_USERNAME:-photo_a}"
PHOTO_A_PASSWORD="${PHOTO_A_PASSWORD:-admin123}"
PHOTO_B_USERNAME="${PHOTO_B_USERNAME:-photo_b}"
PHOTO_B_PASSWORD="${PHOTO_B_PASSWORD:-admin123}"

PHOTOGRAPHER_A_ID=20001
PHOTOGRAPHER_B_ID=20002
PHOTOGRAPHER_A_USER_ID=30001
PHOTOGRAPHER_B_USER_ID=30002
PHOTOGRAPHER_A_BRAND_ID=22001
PHOTOGRAPHER_B_BRAND_ID=22002
PHOTOGRAPHER_A_CATEGORY_ID=210011
PHOTOGRAPHER_A_WORK_ID=230011
PHOTOGRAPHER_B_WORK_ID=230021
PHOTOGRAPHER_A_PACKAGE_ID=250011
PHOTOGRAPHER_B_PACKAGE_ID=250021
PHOTOGRAPHER_A_BOOKING_ID=280011
PHOTOGRAPHER_B_BOOKING_ID=280021

TMP_FILES=()
cleanup() {
  for file in "${TMP_FILES[@]:-}"; do
    if [[ -f "${file}" ]]; then
      rm -f "${file}" || true
    fi
  done
  return 0
}
trap cleanup EXIT

log() {
  printf '\n[%s] %s\n' "$(date '+%H:%M:%S')" "$*" >&2
}

ok() {
  printf 'OK: %s\n' "$*" >&2
}

fail() {
  printf 'FAIL: %s\n' "$*" >&2
  exit 1
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || fail "缺少命令：$1"
}

json_value() {
  local json="$1"
  local expr="$2"
  node -e '
const data = JSON.parse(process.argv[1]);
const expr = process.argv[2].split(".");
let cur = data;
for (const key of expr) {
  if (cur == null) break;
  if (/^\d+$/.test(key)) cur = cur[Number(key)];
  else cur = cur[key];
}
if (cur === undefined || cur === null) process.exit(2);
if (typeof cur === "object") console.log(JSON.stringify(cur));
else console.log(String(cur));
' "$json" "$expr"
}

json_code() {
  json_value "$1" "code" 2>/dev/null || true
}

mysql_exec() {
  docker exec -i "${MYSQL_CONTAINER}" mysql -uroot -p"${MYSQL_PASSWORD}" "${MYSQL_DATABASE}" "$@"
}

mysql_scalar() {
  docker exec -i "${MYSQL_CONTAINER}" mysql -uroot -p"${MYSQL_PASSWORD}" -N -B "${MYSQL_DATABASE}" -e "$1" 2>/dev/null | tail -n 1
}

curl_raw() {
  local method="$1"
  local path="$2"
  local token="${3:-}"
  local data="${4:-}"
  local output_file http_code
  output_file="$(mktemp)"
  TMP_FILES+=("${output_file}")

  if [[ -n "${data}" ]]; then
    http_code="$(curl -sS -o "${output_file}" -w '%{http_code}' -X "${method}" "${BASE_URL}${path}" \
      -H 'Content-Type: application/json' \
      ${token:+-H "Authorization: Bearer ${token}"} \
      --data "${data}" || true)"
  else
    http_code="$(curl -sS -o "${output_file}" -w '%{http_code}' -X "${method}" "${BASE_URL}${path}" \
      ${token:+-H "Authorization: Bearer ${token}"} || true)"
  fi

  printf '%s\n%s' "${http_code}" "$(cat "${output_file}")"
}

api_request() {
  local label="$1"
  local method="$2"
  local path="$3"
  local token="${4:-}"
  local data="${5:-}"
  local expected_code="${6:-200}"
  local raw http_code body api_code

  raw="$(curl_raw "${method}" "${path}" "${token}" "${data}")"
  http_code="$(sed -n '1p' <<<"${raw}")"
  body="$(sed '1d' <<<"${raw}")"
  api_code="$(json_code "${body}")"

  if [[ "${http_code}" != "200" ]]; then
    printf '%s\n' "${body}" >&2
    fail "${label} HTTP 状态不是 200，而是 ${http_code}"
  fi
  if [[ "${api_code}" != "${expected_code}" ]]; then
    printf '%s\n' "${body}" >&2
    fail "${label} 业务 code 不是 ${expected_code}，而是 ${api_code:-空}"
  fi

  ok "${label}"
  printf '%s' "${body}"
}

assert_contains() {
  local label="$1"
  local body="$2"
  local expected="$3"
  if ! grep -q "${expected}" <<<"${body}"; then
    printf '%s\n' "${body}" >&2
    fail "${label} 响应中未找到：${expected}"
  fi
  ok "${label}"
}

assert_not_contains() {
  local label="$1"
  local body="$2"
  local unexpected="$3"
  if grep -q "${unexpected}" <<<"${body}"; then
    printf '%s\n' "${body}" >&2
    fail "${label} 响应中不应包含：${unexpected}"
  fi
  ok "${label}"
}

login() {
  local username="$1"
  local password="$2"
  local code_body uuid captcha_enabled captcha_code login_body login_resp token

  code_body="$(curl -fsS "${BASE_URL}/code")" || fail "无法访问 ${BASE_URL}/code，请确认 ruoyi-gateway 已启动"
  uuid="$(json_value "${code_body}" "uuid" 2>/dev/null || true)"
  captcha_enabled="$(json_value "${code_body}" "captchaEnabled" 2>/dev/null || echo "false")"
  captcha_code=""

  if [[ "${captcha_enabled}" == "true" ]]; then
    [[ -n "${uuid}" ]] || fail "验证码已启用，但 /code 未返回 uuid"
    captcha_code="$(docker exec "${REDIS_CONTAINER}" redis-cli GET "captcha_codes:${uuid}" | tr -d '\r"')"
    [[ -n "${captcha_code}" && "${captcha_code}" != "(nil)" ]] || fail "Redis 中未找到验证码 captcha_codes:${uuid}"
  fi

  login_body="{\"username\":\"${username}\",\"password\":\"${password}\",\"code\":\"${captcha_code}\",\"uuid\":\"${uuid}\"}"
  login_resp="$(api_request "登录 ${username}" POST "/auth/login" "" "${login_body}" 200)"
  token="$(json_value "${login_resp}" "data.access_token" 2>/dev/null || true)"
  [[ -n "${token}" ]] || fail "登录 ${username} 成功响应中没有 data.access_token"
  printf '%s' "${token}"
}

ensure_services() {
  require_cmd docker
  require_cmd curl
  require_cmd node

  docker exec "${MYSQL_CONTAINER}" mysqladmin ping -uroot -p"${MYSQL_PASSWORD}" --silent >/dev/null \
    || fail "MySQL 容器不可用：${MYSQL_CONTAINER}"
  docker exec "${REDIS_CONTAINER}" redis-cli ping >/dev/null \
    || fail "Redis 容器不可用：${REDIS_CONTAINER}"
  curl -fsS "${BASE_URL}/code" >/dev/null \
    || fail "网关不可用：${BASE_URL}。请先启动 ruoyi-gateway。"
}

prepare_seed_data() {
  log "准备 PhotoNest 测试数据"
  mysql_exec < "${ROOT_DIR}/sql/photonest_seed_test_data.sql" >/dev/null

  mysql_exec <<SQL >/dev/null
SET NAMES utf8mb4;

DELETE FROM sys_user_role WHERE user_id IN (${PHOTOGRAPHER_A_USER_ID}, ${PHOTOGRAPHER_B_USER_ID});
DELETE FROM sys_user WHERE user_id IN (${PHOTOGRAPHER_A_USER_ID}, ${PHOTOGRAPHER_B_USER_ID});

INSERT INTO sys_user
  (user_id, dept_id, user_name, nick_name, user_type, email, phonenumber, sex, avatar, password, status, del_flag, create_by, create_time, remark)
VALUES
  (${PHOTOGRAPHER_A_USER_ID}, 103, '${PHOTO_A_USERNAME}', '摄影师A', '00', 'photo_a@example.com', '13900001001', '0', '', '\$2a\$10\$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', 'script', NOW(), 'PhotoNest 摄影师A测试账号'),
  (${PHOTOGRAPHER_B_USER_ID}, 103, '${PHOTO_B_USERNAME}', '摄影师B', '00', 'photo_b@example.com', '13900001002', '0', '', '\$2a\$10\$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', 'script', NOW(), 'PhotoNest 摄影师B测试账号');

INSERT INTO sys_user_role (user_id, role_id)
VALUES (${PHOTOGRAPHER_A_USER_ID}, 2), (${PHOTOGRAPHER_B_USER_ID}, 2);

UPDATE photo_photographer
SET user_id = ${PHOTOGRAPHER_A_USER_ID}, status = '0', del_flag = '0', update_by = 'script', update_time = NOW()
WHERE id = ${PHOTOGRAPHER_A_ID};

UPDATE photo_photographer
SET user_id = ${PHOTOGRAPHER_B_USER_ID}, status = '0', del_flag = '0', update_by = 'script', update_time = NOW()
WHERE id = ${PHOTOGRAPHER_B_ID};
SQL

  ok "已准备超级管理员、摄影师A、摄影师B及 A/B 业务数据"
}

test_admin_api() {
  local token="$1"
  local suffix="script_$(date +%s)"
  local share_code="pn_admin_${suffix}"
  local body new_id

  log "验证 /photo/admin 管理端接口"

  body="$(api_request "管理端查询摄影师列表" GET "/photo/admin/photographer/list?pageNum=1&pageSize=10" "${token}")"
  assert_contains "摄影师列表包含 pn_test_001" "${body}" "pn_test_001"

  body="$(api_request "管理端查询摄影师详情" GET "/photo/admin/photographer/${PHOTOGRAPHER_A_ID}" "${token}")"
  assert_contains "摄影师详情是 A" "${body}" "pn_test_001"

  api_request "管理端创建摄影师" POST "/photo/admin/photographer" "${token}" \
    "{\"brandName\":\"脚本测试摄影师\",\"photographerName\":\"脚本摄影师\",\"shareCode\":\"${share_code}\",\"city\":\"杭州\",\"phone\":\"13812345678\",\"status\":\"0\",\"planType\":\"free\",\"storageLimit\":2147483648,\"storageUsed\":0,\"workLimit\":100,\"packageLimit\":20}" >/dev/null

  new_id="$(mysql_scalar "SELECT id FROM photo_photographer WHERE share_code = '${share_code}' AND del_flag = '0' LIMIT 1;")"
  [[ -n "${new_id}" ]] || fail "管理端创建摄影师后未查到新记录"
  api_request "管理端编辑摄影师" PUT "/photo/admin/photographer" "${token}" \
    "{\"id\":${new_id},\"brandName\":\"脚本测试摄影师-已编辑\",\"photographerName\":\"脚本摄影师\",\"shareCode\":\"${share_code}\",\"city\":\"杭州\",\"phone\":\"13812345678\",\"status\":\"0\"}" >/dev/null
  api_request "管理端禁用摄影师" PUT "/photo/admin/photographer/status" "${token}" \
    "{\"id\":${new_id},\"status\":\"1\"}" >/dev/null
  api_request "管理端启用摄影师" PUT "/photo/admin/photographer/status" "${token}" \
    "{\"id\":${new_id},\"status\":\"0\"}" >/dev/null

  body="$(api_request "管理端查询作品列表" GET "/photo/admin/work/list?photographerId=${PHOTOGRAPHER_A_ID}&pageNum=1&pageSize=10" "${token}")"
  assert_contains "管理端作品列表包含 A 数据" "${body}" "分页测试作品-01-01"

  body="$(api_request "管理端查询套系列表" GET "/photo/admin/package/list?photographerId=${PHOTOGRAPHER_A_ID}&pageNum=1&pageSize=10" "${token}")"
  assert_contains "管理端套系列表包含 A 数据" "${body}" "套系-01-01"

  body="$(api_request "管理端查询预约咨询列表" GET "/photo/admin/booking/list?photographerId=${PHOTOGRAPHER_A_ID}&pageNum=1&pageSize=10" "${token}")"
  assert_contains "管理端预约列表包含 A 数据" "${body}" "PN-SEED-20001"
}

test_photographer_a_api() {
  local token="$1"
  local title="脚本新增作品A"
  local package_name="脚本新增套系A"
  local body work_id package_id

  log "验证摄影师 A /photo/photographer 工作台接口"

  body="$(api_request "摄影师A查询主页配置" GET "/photo/photographer/brand" "${token}")"
  assert_contains "摄影师A主页配置属于 A" "${body}" "Demo Studio 01"

  api_request "摄影师A编辑主页配置" PUT "/photo/photographer/brand" "${token}" \
    "{\"brandName\":\"PhotoNest Demo Studio 01 - A脚本编辑\",\"photographerName\":\"测试摄影师01\",\"subtitle\":\"A脚本工作台编辑\",\"intro\":\"摄影师A脚本验证\",\"city\":\"上海\",\"phone\":\"13800000001\",\"wechatId\":\"photo_seed_001\",\"status\":\"0\"}" >/dev/null

  body="$(api_request "摄影师A查询作品列表" GET "/photo/photographer/work/list?pageNum=1&pageSize=10" "${token}")"
  assert_contains "摄影师A作品列表包含 A 数据" "${body}" "分页测试作品-01-01"
  assert_not_contains "摄影师A作品列表不包含 B 数据" "${body}" "分页测试作品-02-01"

  api_request "摄影师A新增作品" POST "/photo/photographer/work" "${token}" \
    "{\"categoryId\":${PHOTOGRAPHER_A_CATEGORY_ID},\"title\":\"${title}\",\"coverUrl\":\"https://example.com/script/work-a.jpg\",\"tags\":\"脚本,验证\",\"shootType\":\"个人写真\",\"shootLocation\":\"上海\",\"description\":\"脚本新增作品\",\"isHomeRecommend\":\"0\",\"sort\":99,\"status\":\"0\"}" >/dev/null
  work_id="$(mysql_scalar "SELECT id FROM photo_work WHERE photographer_id = ${PHOTOGRAPHER_A_ID} AND create_by = '${PHOTO_A_USERNAME}' AND del_flag = '0' ORDER BY id DESC LIMIT 1;")"
  [[ -n "${work_id}" ]] || fail "摄影师A新增作品后未查到记录"
  api_request "摄影师A编辑自己的作品" PUT "/photo/photographer/work" "${token}" \
    "{\"id\":${work_id},\"categoryId\":${PHOTOGRAPHER_A_CATEGORY_ID},\"title\":\"${title}-已编辑\",\"coverUrl\":\"https://example.com/script/work-a-edit.jpg\",\"status\":\"0\"}" >/dev/null

  body="$(api_request "摄影师A查询套系列表" GET "/photo/photographer/package/list?pageNum=1&pageSize=10" "${token}")"
  assert_contains "摄影师A套系列表包含 A 数据" "${body}" "套系-01-01"
  assert_not_contains "摄影师A套系列表不包含 B 数据" "${body}" "套系-02-01"

  api_request "摄影师A新增套系" POST "/photo/photographer/package" "${token}" \
    "{\"packageName\":\"${package_name}\",\"coverUrl\":\"https://example.com/script/package-a.jpg\",\"priceDisplayType\":\"public\",\"priceText\":\"¥899\",\"price\":899.00,\"depositAmount\":100.00,\"durationMinutes\":120,\"originalPhotoCount\":80,\"retouchPhotoCount\":9,\"suitablePeople\":\"个人写真\",\"serviceContent\":\"脚本新增套系\",\"deliveryCycle\":\"7天\",\"sort\":99,\"status\":\"0\"}" >/dev/null
  package_id="$(mysql_scalar "SELECT id FROM photo_package WHERE photographer_id = ${PHOTOGRAPHER_A_ID} AND create_by = '${PHOTO_A_USERNAME}' AND del_flag = '0' ORDER BY id DESC LIMIT 1;")"
  [[ -n "${package_id}" ]] || fail "摄影师A新增套系后未查到记录"
  api_request "摄影师A编辑自己的套系" PUT "/photo/photographer/package" "${token}" \
    "{\"id\":${package_id},\"packageName\":\"${package_name}-已编辑\",\"coverUrl\":\"https://example.com/script/package-a-edit.jpg\",\"priceDisplayType\":\"public\",\"priceText\":\"¥999\",\"price\":999.00,\"status\":\"0\"}" >/dev/null

  body="$(api_request "摄影师A查询预约咨询列表" GET "/photo/photographer/booking/list?pageNum=1&pageSize=10" "${token}")"
  assert_contains "摄影师A预约列表包含 A 数据" "${body}" "PN-SEED-20001"
  assert_not_contains "摄影师A预约列表不包含 B 数据" "${body}" "PN-SEED-20002"

  api_request "摄影师A修改自己的预约状态" PUT "/photo/photographer/booking/status" "${token}" \
    "{\"id\":${PHOTOGRAPHER_A_BOOKING_ID},\"status\":\"1\",\"remark\":\"摄影师A脚本已跟进\"}" >/dev/null
}

test_photographer_b_api() {
  local token="$1"
  local body

  log "验证摄影师 B /photo/photographer 工作台接口"

  body="$(api_request "摄影师B查询主页配置" GET "/photo/photographer/brand" "${token}")"
  assert_contains "摄影师B主页配置属于 B" "${body}" "Demo Studio 02"

  body="$(api_request "摄影师B查询预约咨询列表" GET "/photo/photographer/booking/list?pageNum=1&pageSize=10" "${token}")"
  assert_contains "摄影师B预约列表包含 B 数据" "${body}" "PN-SEED-20002"
  assert_not_contains "摄影师B预约列表不包含 A 数据" "${body}" "PN-SEED-20001"
}

test_isolation() {
  local token_a="$1"
  local token_b="$2"
  local body old_b_brand old_b_work_title old_b_package_name now_b_brand now_b_work_title now_b_package_name

  log "验证 photographer_id 数据隔离"

  body="$(api_request "摄影师A查询摄影师B预约详情" GET "/photo/photographer/booking/${PHOTOGRAPHER_B_BOOKING_ID}" "${token_a}")"
  if [[ "$(json_value "${body}" "data" 2>/dev/null || true)" != "" ]]; then
    printf '%s\n' "${body}" >&2
    fail "摄影师A不应查询到摄影师B预约详情"
  fi
  ok "摄影师A不能查询摄影师B预约详情"

  old_b_work_title="$(mysql_scalar "SELECT title FROM photo_work WHERE id = ${PHOTOGRAPHER_B_WORK_ID};")"
  body="$(api_request "摄影师A尝试修改摄影师B作品" PUT "/photo/photographer/work" "${token_a}" \
    "{\"id\":${PHOTOGRAPHER_B_WORK_ID},\"title\":\"A非法修改B作品\",\"status\":\"0\"}" 500)"
  assert_contains "摄影师A修改B作品被拒绝" "${body}" "无权"
  now_b_work_title="$(mysql_scalar "SELECT title FROM photo_work WHERE id = ${PHOTOGRAPHER_B_WORK_ID};")"
  [[ "${old_b_work_title}" == "${now_b_work_title}" ]] || fail "摄影师B作品标题被非法修改"
  ok "摄影师B作品数据未被 A 修改"

  old_b_package_name="$(mysql_scalar "SELECT package_name FROM photo_package WHERE id = ${PHOTOGRAPHER_B_PACKAGE_ID};")"
  body="$(api_request "摄影师A尝试修改摄影师B套系" PUT "/photo/photographer/package" "${token_a}" \
    "{\"id\":${PHOTOGRAPHER_B_PACKAGE_ID},\"packageName\":\"A非法修改B套系\",\"status\":\"0\"}" 500)"
  assert_contains "摄影师A修改B套系被拒绝" "${body}" "无权"
  now_b_package_name="$(mysql_scalar "SELECT package_name FROM photo_package WHERE id = ${PHOTOGRAPHER_B_PACKAGE_ID};")"
  [[ "${old_b_package_name}" == "${now_b_package_name}" ]] || fail "摄影师B套系名称被非法修改"
  ok "摄影师B套系数据未被 A 修改"

  old_b_brand="$(mysql_scalar "SELECT brand_name FROM photo_brand_config WHERE photographer_id = ${PHOTOGRAPHER_B_ID};")"
  api_request "摄影师A尝试携带B主页ID编辑主页配置" PUT "/photo/photographer/brand" "${token_a}" \
    "{\"id\":${PHOTOGRAPHER_B_BRAND_ID},\"photographerId\":${PHOTOGRAPHER_B_ID},\"brandName\":\"A非法修改B主页\",\"photographerName\":\"非法\",\"status\":\"0\"}" >/dev/null
  now_b_brand="$(mysql_scalar "SELECT brand_name FROM photo_brand_config WHERE photographer_id = ${PHOTOGRAPHER_B_ID};")"
  [[ "${old_b_brand}" == "${now_b_brand}" ]] || fail "摄影师B主页配置被非法修改"
  ok "摄影师A不能修改摄影师B主页配置"

  body="$(api_request "摄影师B复查主页配置" GET "/photo/photographer/brand" "${token_b}")"
  assert_contains "摄影师B主页配置仍是 B" "${body}" "${old_b_brand}"
}

main() {
  log "检查本地依赖服务"
  ensure_services
  ok "Docker MySQL、Redis 与网关可访问"

  prepare_seed_data

  log "通过网关登录并获取 token"
  ADMIN_TOKEN="$(login "${ADMIN_USERNAME}" "${ADMIN_PASSWORD}")"
  PHOTO_A_TOKEN="$(login "${PHOTO_A_USERNAME}" "${PHOTO_A_PASSWORD}")"
  PHOTO_B_TOKEN="$(login "${PHOTO_B_USERNAME}" "${PHOTO_B_PASSWORD}")"
  ok "已获取超级管理员、摄影师A、摄影师B token"

  test_admin_api "${ADMIN_TOKEN}"
  test_photographer_a_api "${PHOTO_A_TOKEN}"
  test_photographer_b_api "${PHOTO_B_TOKEN}"
  test_isolation "${PHOTO_A_TOKEN}" "${PHOTO_B_TOKEN}"

  log "PhotoNest 管理端与摄影师工作台自动化验证全部通过"
}

main "$@"
