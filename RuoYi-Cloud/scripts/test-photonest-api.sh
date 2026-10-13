#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BASE_URL="${BASE_URL:-http://localhost:8080}"
SHARE_CODE="${SHARE_CODE:-pn_test_001}"
MYSQL_CONTAINER="${MYSQL_CONTAINER:-ruoyi-mysql}"
MYSQL_PASSWORD="${MYSQL_PASSWORD:-password}"

mysql_exec() {
  docker exec -i "${MYSQL_CONTAINER}" mysql -uroot -p"${MYSQL_PASSWORD}" ry-cloud "$@"
}

curl_json() {
  local method="$1"
  local path="$2"
  local data="${3:-}"
  if [[ -n "${data}" ]]; then
    if [[ -n "${PHOTO_TOKEN:-}" ]]; then
      curl -fsS -X "${method}" "${BASE_URL}${path}" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer ${PHOTO_TOKEN}" \
        --data "${data}"
    else
      curl -fsS -X "${method}" "${BASE_URL}${path}" \
        -H "Content-Type: application/json" \
        --data "${data}"
    fi
  else
    if [[ -n "${PHOTO_TOKEN:-}" ]]; then
      curl -fsS -X "${method}" "${BASE_URL}${path}" \
        -H "Authorization: Bearer ${PHOTO_TOKEN}"
    else
      curl -fsS -X "${method}" "${BASE_URL}${path}"
    fi
  fi
}

assert_contains() {
  local body="$1"
  local expected="$2"
  local label="$3"
  if ! grep -q "${expected}" <<<"${body}"; then
    echo "Assertion failed for ${label}: expected response to contain '${expected}'" >&2
    echo "Response:" >&2
    echo "${body}" >&2
    exit 1
  fi
  echo "OK: ${label}"
}

echo "Preparing minimal PhotoNest test data in MySQL..."
mysql_exec <<SQL
SET NAMES utf8mb4;

DELETE FROM photo_booking WHERE photographer_id = 9001;
DELETE FROM photo_customer WHERE photographer_id = 9001;
DELETE FROM photo_package_item WHERE photographer_id = 9001;
DELETE FROM photo_package WHERE photographer_id = 9001;
DELETE FROM photo_work_image WHERE photographer_id = 9001;
DELETE FROM photo_work WHERE photographer_id = 9001;
DELETE FROM photo_work_category WHERE photographer_id = 9001;
DELETE FROM photo_brand_config WHERE photographer_id = 9001;
DELETE FROM photo_photographer WHERE id = 9001 OR share_code = '${SHARE_CODE}';

INSERT INTO photo_photographer
  (id, user_id, brand_name, photographer_name, share_code, avatar, cover_image, city, phone, wechat_id, status, plan_type, storage_limit, storage_used, work_limit, package_limit, create_by, create_time, del_flag)
VALUES
  (9001, NULL, 'PhotoNest Test Studio', '测试摄影师', '${SHARE_CODE}', '', 'https://example.com/cover.jpg', '上海', '13800000000', 'photo_test', '0', 'free', 2147483648, 0, 100, 20, 'test', sysdate(), '0');

INSERT INTO photo_brand_config
  (id, photographer_id, brand_name, photographer_name, logo_url, cover_image, subtitle, intro, about_content, city, phone, wechat_id, status, create_by, create_time, del_flag)
VALUES
  (9001, 9001, 'PhotoNest Test Studio', '测试摄影师', 'https://example.com/logo.jpg', 'https://example.com/cover.jpg', 'Light and Memory', '测试摄影主页简介', '这里是关于页内容', '上海', '13800000000', 'photo_test', '0', 'test', sysdate(), '0');

INSERT INTO photo_work_category
  (id, photographer_id, category_name, sort, status, create_by, create_time, del_flag)
VALUES
  (9001, 9001, '写真', 1, '0', 'test', sysdate(), '0');

INSERT INTO photo_work
  (id, photographer_id, category_id, title, cover_url, tags, shoot_type, shoot_location, shoot_time, description, is_home_recommend, publish_time, sort, view_count, status, create_by, create_time, del_flag)
VALUES
  (9001, 9001, 9001, '测试作品', 'https://example.com/work-cover.jpg', '写真,测试', '写真', '上海', sysdate(), '测试作品说明', '1', sysdate(), 1, 0, '0', 'test', sysdate(), '0');

INSERT INTO photo_work_image
  (id, photographer_id, work_id, original_url, display_url, thumbnail_url, watermark_url, file_name, file_size, width, height, sort, status, create_by, create_time, del_flag)
VALUES
  (9001, 9001, 9001, 'https://example.com/original.jpg', 'https://example.com/display.jpg', 'https://example.com/thumb.jpg', 'https://example.com/watermark.jpg', 'display.jpg', 1024, 1200, 800, 1, '0', 'test', sysdate(), '0');

INSERT INTO photo_package
  (id, photographer_id, package_name, cover_url, price_display_type, price_text, price, deposit_amount, duration_minutes, original_photo_count, retouch_photo_count, suitable_people, service_content, delivery_cycle, sort, status, create_by, create_time, del_flag)
VALUES
  (9001, 9001, '测试写真套系', 'https://example.com/package-cover.jpg', 'public', '¥699', 699.00, 100.00, 120, 80, 9, '个人写真', '拍摄服务内容', '7天', 1, '0', 'test', sysdate(), '0');

INSERT INTO photo_package_item
  (id, photographer_id, package_id, item_name, item_value, sort, create_by, create_time, del_flag)
VALUES
  (9001, 9001, 9001, '精修', '9张', 1, 'test', sysdate(), '0');
SQL

echo "Testing PhotoNest public APIs via ${BASE_URL} ..."

login_response="$(curl_json POST "/photo/app/auth/wechat-login" "{\"shareCode\":\"${SHARE_CODE}\",\"code\":\"dev-smoke-${SHARE_CODE}\"}")"
PHOTO_TOKEN="$(node -e "const body=JSON.parse(process.argv[1]); const data=body.data||body; console.log(data.access_token||data.token||'')" "${login_response}")"
if [[ -z "${PHOTO_TOKEN}" ]]; then
  echo "Failed to obtain PhotoNest customer token" >&2
  echo "${login_response}" >&2
  exit 1
fi
echo "OK: customer wechat login"

home_response="$(curl_json GET "/photo/app/home/${SHARE_CODE}")"
assert_contains "${home_response}" "PhotoNest Test Studio" "home by shareCode"

work_response="$(curl_json GET "/photo/app/work/list/${SHARE_CODE}")"
assert_contains "${work_response}" "测试作品" "work list"

package_response="$(curl_json GET "/photo/app/package/list/${SHARE_CODE}")"
assert_contains "${package_response}" "测试写真套系" "package list"

booking_payload='{
  "customerName": "测试客户",
  "phone": "13900000000",
  "wechatId": "client_test",
  "shootType": "写真",
  "packageId": 9001,
  "expectedDate": "2026-06-10",
  "expectedTime": "下午 2 点以后",
  "expectedLocation": "上海",
  "peopleCount": 1,
  "hasChild": "0",
  "requirement": "想咨询同款拍摄",
  "sourceChannel": "manual_share",
  "sourcePage": "home",
  "sourceType": "page"
}'
booking_response="$(curl_json POST "/photo/app/booking/${SHARE_CODE}" "${booking_payload}")"
assert_contains "${booking_response}" "\"code\":200" "booking create"

echo "PhotoNest API smoke test passed."
