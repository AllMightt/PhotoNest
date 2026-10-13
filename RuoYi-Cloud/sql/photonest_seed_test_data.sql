SET NAMES utf8mb4;

USE `ry-cloud`;

-- ----------------------------
-- PhotoNest MVP 分页测试数据
-- 可重复执行：会清理本脚本创建的固定测试数据后重新插入。
-- 重点测试入口摄影师 share_code = pn_test_001。
-- ----------------------------

DROP TEMPORARY TABLE IF EXISTS tmp_photo_seed_photographer;
CREATE TEMPORARY TABLE tmp_photo_seed_photographer (
  id bigint(20) NOT NULL PRIMARY KEY
);

INSERT IGNORE INTO tmp_photo_seed_photographer (id) VALUES
(20001), (20002), (20003), (20004), (20005),
(20006), (20007), (20008), (20009), (20010),
(20011), (20012), (20013), (20014), (20015),
(20016), (20017), (20018), (20019), (20020);

INSERT IGNORE INTO tmp_photo_seed_photographer (id)
SELECT id
FROM photo_photographer
WHERE id BETWEEN 20001 AND 20020
   OR share_code = 'pn_test_001'
   OR share_code LIKE 'pn_demo_%';

DELETE FROM photo_booking WHERE photographer_id IN (SELECT id FROM tmp_photo_seed_photographer);
DELETE FROM photo_customer WHERE photographer_id IN (SELECT id FROM tmp_photo_seed_photographer);
DELETE FROM photo_package_item WHERE photographer_id IN (SELECT id FROM tmp_photo_seed_photographer);
DELETE FROM photo_package WHERE photographer_id IN (SELECT id FROM tmp_photo_seed_photographer);
DELETE FROM photo_work_image WHERE photographer_id IN (SELECT id FROM tmp_photo_seed_photographer);
DELETE FROM photo_work WHERE photographer_id IN (SELECT id FROM tmp_photo_seed_photographer);
DELETE FROM photo_work_category WHERE photographer_id IN (SELECT id FROM tmp_photo_seed_photographer);
DELETE FROM photo_brand_config WHERE photographer_id IN (SELECT id FROM tmp_photo_seed_photographer);
DELETE FROM photo_photographer WHERE id IN (SELECT id FROM tmp_photo_seed_photographer);

DROP TEMPORARY TABLE IF EXISTS tmp_photo_seed_photographer;

DELIMITER $$

DROP PROCEDURE IF EXISTS seed_photonest_mvp_data $$
CREATE PROCEDURE seed_photonest_mvp_data()
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE j INT DEFAULT 1;
  DECLARE photographer_id BIGINT;
  DECLARE category_a_id BIGINT;
  DECLARE category_b_id BIGINT;
  DECLARE work_id BIGINT;
  DECLARE image_id BIGINT;
  DECLARE package_id BIGINT;
  DECLARE package_item_id BIGINT;
  DECLARE customer_id BIGINT;
  DECLARE booking_id BIGINT;
  DECLARE share_code_value VARCHAR(64);
  DECLARE city_value VARCHAR(50);
  DECLARE shoot_type_value VARCHAR(50);
  DECLARE price_type_value VARCHAR(20);
  DECLARE source_channel_value VARCHAR(50);
  DECLARE source_type_value VARCHAR(20);

  WHILE i <= 20 DO
    SET photographer_id = 20000 + i;
    SET category_a_id = 210000 + i * 10 + 1;
    SET category_b_id = 210000 + i * 10 + 2;
    SET share_code_value = IF(i = 1, 'pn_test_001', CONCAT('pn_demo_', LPAD(i, 3, '0')));
    SET city_value = ELT(((i - 1) MOD 6) + 1, '上海', '杭州', '苏州', '南京', '成都', '深圳');

    INSERT INTO photo_photographer
      (id, user_id, brand_name, photographer_name, share_code, avatar, cover_image, city, phone, wechat_id, wechat_qr,
       xiaohongshu_id, xiaohongshu_qr, douyin_id, douyin_qr, status, plan_type, expire_time, storage_limit, storage_used,
       work_limit, package_limit, create_by, create_time, update_by, update_time, remark, del_flag)
    VALUES
      (photographer_id, 30000 + i, CONCAT('PhotoNest Demo Studio ', LPAD(i, 2, '0')), CONCAT('测试摄影师', LPAD(i, 2, '0')),
       share_code_value, CONCAT('https://example.com/avatar/', i, '.jpg'), CONCAT('https://example.com/cover/', i, '.jpg'),
       city_value, CONCAT('1380000', LPAD(i, 4, '0')), CONCAT('photo_demo_', LPAD(i, 3, '0')),
       CONCAT('https://example.com/qr/wechat/', i, '.png'), CONCAT('redbook_demo_', LPAD(i, 3, '0')),
       CONCAT('https://example.com/qr/xhs/', i, '.png'), CONCAT('douyin_demo_', LPAD(i, 3, '0')),
       CONCAT('https://example.com/qr/douyin/', i, '.png'), IF(i MOD 10 = 0, '1', '0'), IF(i MOD 3 = 0, 'pro', 'free'),
       DATE_ADD(NOW(), INTERVAL (180 + i) DAY), 2147483648 + i * 104857600, i * 1048576, 100, 20,
       'seed', NOW(), 'seed', NOW(), 'PhotoNest分页测试摄影师', '0');

    INSERT INTO photo_brand_config
      (id, photographer_id, brand_name, photographer_name, logo_url, cover_image, subtitle, intro, about_content, city,
       phone, wechat_id, wechat_qr, xiaohongshu_id, xiaohongshu_qr, douyin_id, douyin_qr, shoot_process, faq_content,
       status, create_by, create_time, update_by, update_time, remark, del_flag)
    VALUES
      (22000 + i, photographer_id, CONCAT('PhotoNest Demo Studio ', LPAD(i, 2, '0')), CONCAT('测试摄影师', LPAD(i, 2, '0')),
       CONCAT('https://example.com/logo/', i, '.jpg'), CONCAT('https://example.com/brand-cover/', i, '.jpg'),
       CONCAT('Light, Story and Memory ', LPAD(i, 2, '0')), CONCAT(city_value, '本地摄影服务，适合写真、亲子、情侣与家庭纪实。'),
       CONCAT('这里是摄影师 ', LPAD(i, 2, '0'), ' 的关于页内容，展示品牌理念、服务城市、拍摄风格和联系方式。'),
       city_value, CONCAT('1380000', LPAD(i, 4, '0')), CONCAT('photo_demo_', LPAD(i, 3, '0')),
       CONCAT('https://example.com/qr/wechat/', i, '.png'), CONCAT('redbook_demo_', LPAD(i, 3, '0')),
       CONCAT('https://example.com/qr/xhs/', i, '.png'), CONCAT('douyin_demo_', LPAD(i, 3, '0')),
       CONCAT('https://example.com/qr/douyin/', i, '.png'), '沟通需求 -> 确认档期 -> 支付定金 -> 拍摄 -> 选片精修 -> 交付成片',
       'Q: 多久交付？A: 通常7-14天。Q: 可以改期吗？A: 提前48小时可协调一次。', '0',
       'seed', NOW(), 'seed', NOW(), 'PhotoNest分页测试主页配置', '0');

    INSERT INTO photo_work_category
      (id, photographer_id, category_name, category_icon, sort, status, create_by, create_time, update_by, update_time, remark, del_flag)
    VALUES
      (category_a_id, photographer_id, '个人写真', 'https://example.com/icon/portrait.png', 1, '0', 'seed', NOW(), 'seed', NOW(), '测试分类', '0'),
      (category_b_id, photographer_id, '亲子家庭', 'https://example.com/icon/family.png', 2, '0', 'seed', NOW(), 'seed', NOW(), '测试分类', '0');

    SET j = 1;
    WHILE j <= 2 DO
      SET work_id = 230000 + i * 10 + j;
      SET shoot_type_value = IF(j = 1, '个人写真', '亲子家庭');

      INSERT INTO photo_work
        (id, photographer_id, category_id, title, cover_url, tags, shoot_type, shoot_location, shoot_time, description,
         is_home_recommend, publish_time, sort, view_count, status, create_by, create_time, update_by, update_time, remark, del_flag)
      VALUES
        (work_id, photographer_id, IF(j = 1, category_a_id, category_b_id),
         CONCAT('分页测试作品-', LPAD(i, 2, '0'), '-', LPAD(j, 2, '0')),
         CONCAT('https://example.com/work/', work_id, '/cover.jpg'), CONCAT(shoot_type_value, ',自然光,分页测试'),
         shoot_type_value, CONCAT(city_value, ' 城市外景地'), DATE_SUB(NOW(), INTERVAL (i * 2 + j) DAY),
         CONCAT('这是 ', city_value, ' 摄影师的 ', shoot_type_value, ' 作品，用于测试作品列表、详情和首页推荐分页。'),
         IF((i <= 10 AND j = 1) OR (i = 1 AND j = 2), '1', '0'), DATE_SUB(NOW(), INTERVAL (i * 2 + j) HOUR),
         i * 10 + j, i * 100 + j, '0', 'seed', NOW(), 'seed', NOW(), 'PhotoNest分页测试作品', '0');

      SET image_id = 240000 + i * 100 + j * 10 + 1;
      INSERT INTO photo_work_image
        (id, photographer_id, work_id, original_url, display_url, thumbnail_url, watermark_url, file_name, file_size,
         width, height, sort, status, create_by, create_time, update_by, update_time, remark, del_flag)
      VALUES
        (image_id, photographer_id, work_id, CONCAT('https://example.com/work/', work_id, '/original-1.jpg'),
         CONCAT('https://example.com/work/', work_id, '/display-1.jpg'), CONCAT('https://example.com/work/', work_id, '/thumb-1.jpg'),
         CONCAT('https://example.com/work/', work_id, '/watermark-1.jpg'), CONCAT('work-', work_id, '-1.jpg'),
         2048000 + i * 1000 + j, 1600, 1067, 1, '0', 'seed', NOW(), 'seed', NOW(), '分页测试作品图片', '0'),
        (image_id + 1, photographer_id, work_id, CONCAT('https://example.com/work/', work_id, '/original-2.jpg'),
         CONCAT('https://example.com/work/', work_id, '/display-2.jpg'), CONCAT('https://example.com/work/', work_id, '/thumb-2.jpg'),
         CONCAT('https://example.com/work/', work_id, '/watermark-2.jpg'), CONCAT('work-', work_id, '-2.jpg'),
         2049000 + i * 1000 + j, 1600, 1067, 2, '0', 'seed', NOW(), 'seed', NOW(), '分页测试作品图片', '0');

      SET package_id = 250000 + i * 10 + j;
      SET price_type_value = ELT(((i + j - 2) MOD 4) + 1, 'public', 'from', 'negotiable', 'hidden');

      INSERT INTO photo_package
        (id, photographer_id, package_name, cover_url, price_display_type, price_text, price, deposit_amount,
         duration_minutes, original_photo_count, retouch_photo_count, suitable_people, service_content, delivery_cycle,
         extra_photo_price, extra_hour_price, notice, reschedule_rule, sort, status, create_by, create_time, update_by,
         update_time, remark, del_flag)
      VALUES
        (package_id, photographer_id, CONCAT(shoot_type_value, '套系-', LPAD(i, 2, '0'), '-', LPAD(j, 2, '0')),
         CONCAT('https://example.com/package/', package_id, '/cover.jpg'), price_type_value,
         CASE price_type_value
           WHEN 'public' THEN CONCAT('¥', 599 + i * 30 + j * 80)
           WHEN 'from' THEN CONCAT('¥', 499 + i * 20, '起')
           WHEN 'negotiable' THEN '价格面议'
           ELSE '私信咨询'
         END,
         IF(price_type_value IN ('public', 'from'), 599 + i * 30 + j * 80, NULL),
         IF(price_type_value IN ('public', 'from'), 100 + j * 50, NULL),
         90 + j * 30, 60 + j * 20, 6 + j * 3, CONCAT(shoot_type_value, '客户'),
         CONCAT('含前期沟通、', shoot_type_value, '拍摄、基础调色和精修交付。'), IF(j = 1, '7天', '14天'),
         80.00 + j * 20, 150.00 + j * 50, '请提前10分钟到达拍摄地点，妆造需求请提前沟通。',
         '拍摄前48小时可免费协调一次档期。', i * 10 + j, '0', 'seed', NOW(), 'seed', NOW(), 'PhotoNest分页测试套系', '0');

      SET package_item_id = 260000 + i * 100 + j * 10 + 1;
      INSERT INTO photo_package_item
        (id, photographer_id, package_id, item_name, item_value, sort, create_by, create_time, update_by, update_time, remark, del_flag)
      VALUES
        (package_item_id, photographer_id, package_id, '拍摄时长', CONCAT(90 + j * 30, '分钟'), 1, 'seed', NOW(), 'seed', NOW(), '分页测试套系明细', '0'),
        (package_item_id + 1, photographer_id, package_id, '精修张数', CONCAT(6 + j * 3, '张'), 2, 'seed', NOW(), 'seed', NOW(), '分页测试套系明细', '0');

      SET customer_id = 270000 + i * 10 + j;
      INSERT INTO photo_customer
        (id, photographer_id, openid, nickname, avatar_url, real_name, phone, wechat_id, status, create_by, create_time,
         update_by, update_time, remark, del_flag)
      VALUES
        (customer_id, photographer_id, CONCAT('openid_seed_', photographer_id, '_', j), CONCAT('测试客户昵称', LPAD(i, 2, '0'), LPAD(j, 2, '0')),
         CONCAT('https://example.com/customer/avatar/', customer_id, '.jpg'), CONCAT('测试客户', LPAD(i, 2, '0'), LPAD(j, 2, '0')),
         CONCAT('139', LPAD(i, 4, '0'), LPAD(j, 4, '0')), CONCAT('client_seed_', LPAD(i, 2, '0'), '_', j),
         '0', 'seed', NOW(), 'seed', NOW(), 'PhotoNest分页测试客户', '0');

      SET booking_id = 280000 + i * 10 + j;
      SET source_channel_value = ELT(((i + j - 2) MOD 5) + 1, 'xiaohongshu', 'douyin', 'wechat', 'friend_circle', 'manual_share');
      SET source_type_value = IF(j = 1, 'work', 'package');
      INSERT INTO photo_booking
        (id, photographer_id, customer_id, booking_no, customer_name, phone, wechat_id, shoot_type, package_id,
         expected_date, expected_time, expected_location, people_count, has_child, requirement, source_channel,
         source_page, source_type, source_work_id, source_package_id, status, create_by, create_time, update_by,
         update_time, remark, del_flag)
      VALUES
        (booking_id, photographer_id, customer_id, CONCAT('PN-SEED-', photographer_id, '-', LPAD(j, 2, '0')),
         CONCAT('测试客户', LPAD(i, 2, '0'), LPAD(j, 2, '0')), CONCAT('139', LPAD(i, 4, '0'), LPAD(j, 4, '0')),
         CONCAT('client_seed_', LPAD(i, 2, '0'), '_', j), shoot_type_value, package_id,
         DATE_ADD(CURDATE(), INTERVAL (i + j) DAY), IF(j = 1, '上午 10 点以后', '下午 2 点以后'),
         CONCAT(city_value, ' 可商量'), IF(j = 1, 1, 3), IF(j = 1, '0', '1'),
         CONCAT('想咨询 ', shoot_type_value, ' 拍摄，希望了解档期、价格和交付周期。'), source_channel_value,
         IF(j = 1, 'work-detail', 'package-detail'), source_type_value, IF(j = 1, work_id, NULL), IF(j = 2, package_id, NULL),
         CAST(((i + j - 2) MOD 5) AS CHAR), 'seed', DATE_SUB(NOW(), INTERVAL (i * 2 + j) HOUR),
         'seed', NOW(), 'PhotoNest分页测试预约咨询', '0');

      SET j = j + 1;
    END WHILE;

    SET i = i + 1;
  END WHILE;

  -- 为 pn_test_001 额外补充数据，方便单摄影师维度测试分页。
  SET photographer_id = 20001;
  SET category_a_id = 210011;
  SET i = 3;
  WHILE i <= 24 DO
    SET work_id = 231000 + i;
    INSERT INTO photo_work
      (id, photographer_id, category_id, title, cover_url, tags, shoot_type, shoot_location, shoot_time, description,
       is_home_recommend, publish_time, sort, view_count, status, create_by, create_time, update_by, update_time, remark, del_flag)
    VALUES
      (work_id, photographer_id, category_a_id, CONCAT('pn_test_001分页作品-', LPAD(i, 2, '0')),
       CONCAT('https://example.com/pn-test/work/', i, '/cover.jpg'), '个人写真,分页测试,pn_test_001',
       '个人写真', '上海 城市外景地', DATE_SUB(NOW(), INTERVAL i DAY),
       CONCAT('pn_test_001 专用分页测试作品第 ', i, ' 条。'), IF(i <= 10, '1', '0'),
       DATE_SUB(NOW(), INTERVAL i HOUR), i, i * 10, '0', 'seed', NOW(), 'seed', NOW(), 'pn_test_001作品分页补充', '0');

    INSERT INTO photo_work_image
      (id, photographer_id, work_id, original_url, display_url, thumbnail_url, watermark_url, file_name, file_size,
       width, height, sort, status, create_by, create_time, update_by, update_time, remark, del_flag)
    VALUES
      (243000 + i, photographer_id, work_id, CONCAT('https://example.com/pn-test/work/', i, '/original.jpg'),
       CONCAT('https://example.com/pn-test/work/', i, '/display.jpg'), CONCAT('https://example.com/pn-test/work/', i, '/thumb.jpg'),
       CONCAT('https://example.com/pn-test/work/', i, '/watermark.jpg'), CONCAT('pn-test-work-', i, '.jpg'),
       2097152 + i, 1600, 1067, 1, '0', 'seed', NOW(), 'seed', NOW(), 'pn_test_001作品图片分页补充', '0');

    SET i = i + 1;
  END WHILE;

  SET i = 3;
  WHILE i <= 24 DO
    SET package_id = 251000 + i;
    INSERT INTO photo_package
      (id, photographer_id, package_name, cover_url, price_display_type, price_text, price, deposit_amount,
       duration_minutes, original_photo_count, retouch_photo_count, suitable_people, service_content, delivery_cycle,
       extra_photo_price, extra_hour_price, notice, reschedule_rule, sort, status, create_by, create_time, update_by,
       update_time, remark, del_flag)
    VALUES
      (package_id, photographer_id, CONCAT('pn_test_001分页套系-', LPAD(i, 2, '0')),
       CONCAT('https://example.com/pn-test/package/', i, '/cover.jpg'), IF(i MOD 4 = 0, 'negotiable', 'public'),
       IF(i MOD 4 = 0, '价格面议', CONCAT('¥', 699 + i * 20)), IF(i MOD 4 = 0, NULL, 699 + i * 20),
       IF(i MOD 4 = 0, NULL, 100.00), 90 + i, 80 + i, 9 + (i MOD 6), '个人、情侣、家庭',
       CONCAT('pn_test_001 专用分页测试套系第 ', i, ' 条。'), IF(i MOD 2 = 0, '7天', '14天'),
       100.00, 200.00, '测试套系拍摄须知。', '测试套系改期规则。', i, '0',
       'seed', NOW(), 'seed', NOW(), 'pn_test_001套系分页补充', '0');

    INSERT INTO photo_package_item
      (id, photographer_id, package_id, item_name, item_value, sort, create_by, create_time, update_by, update_time, remark, del_flag)
    VALUES
      (263000 + i, photographer_id, package_id, '精修张数', CONCAT(9 + (i MOD 6), '张'), 1, 'seed', NOW(), 'seed', NOW(), 'pn_test_001套系明细分页补充', '0');

    SET i = i + 1;
  END WHILE;

  SET i = 3;
  WHILE i <= 24 DO
    SET customer_id = 271000 + i;
    SET package_id = IF(i <= 12, 250011, 251000 + i);
    INSERT INTO photo_customer
      (id, photographer_id, openid, nickname, avatar_url, real_name, phone, wechat_id, status, create_by, create_time,
       update_by, update_time, remark, del_flag)
    VALUES
      (customer_id, photographer_id, CONCAT('openid_seed_20001_extra_', i), CONCAT('pn测试客户昵称', LPAD(i, 2, '0')),
       CONCAT('https://example.com/pn-test/customer/', i, '.jpg'), CONCAT('pn测试客户', LPAD(i, 2, '0')),
       CONCAT('1392001', LPAD(i, 4, '0')), CONCAT('pn_client_', LPAD(i, 2, '0')),
       '0', 'seed', NOW(), 'seed', NOW(), 'pn_test_001客户分页补充', '0');

    INSERT INTO photo_booking
      (id, photographer_id, customer_id, booking_no, customer_name, phone, wechat_id, shoot_type, package_id,
       expected_date, expected_time, expected_location, people_count, has_child, requirement, source_channel,
       source_page, source_type, source_work_id, source_package_id, status, create_by, create_time, update_by,
       update_time, remark, del_flag)
    VALUES
      (281000 + i, photographer_id, customer_id, CONCAT('PN-SEED-20001-EXTRA-', LPAD(i, 2, '0')),
       CONCAT('pn测试客户', LPAD(i, 2, '0')), CONCAT('1392001', LPAD(i, 4, '0')), CONCAT('pn_client_', LPAD(i, 2, '0')),
       '个人写真', package_id, DATE_ADD(CURDATE(), INTERVAL i DAY), IF(i MOD 2 = 0, '周末都可以', '晚上 7 点以后'),
       '上海 可商量', 1 + (i MOD 4), IF(i MOD 5 = 0, '1', '0'), CONCAT('pn_test_001 第 ', i, ' 条预约分页测试。'),
       ELT(((i - 1) MOD 5) + 1, 'xiaohongshu', 'douyin', 'wechat', 'friend_circle', 'manual_share'),
       IF(i MOD 2 = 0, 'home', 'package-detail'), IF(i MOD 2 = 0, 'page', 'package'), NULL, IF(i MOD 2 = 0, NULL, package_id),
       CAST(((i - 1) MOD 5) AS CHAR), 'seed', DATE_SUB(NOW(), INTERVAL i HOUR),
       'seed', NOW(), 'pn_test_001预约分页补充', '0');

    SET i = i + 1;
  END WHILE;
END $$

CALL seed_photonest_mvp_data() $$
DROP PROCEDURE IF EXISTS seed_photonest_mvp_data $$

DELIMITER ;

-- ----------------------------
-- 数据量校验
-- ----------------------------
SELECT 'photo_photographer' AS table_name, COUNT(*) AS seed_count
FROM photo_photographer
WHERE id BETWEEN 20001 AND 20020
UNION ALL
SELECT 'photo_brand_config', COUNT(*) FROM photo_brand_config WHERE photographer_id BETWEEN 20001 AND 20020
UNION ALL
SELECT 'photo_work_category', COUNT(*) FROM photo_work_category WHERE photographer_id BETWEEN 20001 AND 20020
UNION ALL
SELECT 'photo_work', COUNT(*) FROM photo_work WHERE photographer_id BETWEEN 20001 AND 20020
UNION ALL
SELECT 'photo_work_image', COUNT(*) FROM photo_work_image WHERE photographer_id BETWEEN 20001 AND 20020
UNION ALL
SELECT 'photo_package', COUNT(*) FROM photo_package WHERE photographer_id BETWEEN 20001 AND 20020
UNION ALL
SELECT 'photo_package_item', COUNT(*) FROM photo_package_item WHERE photographer_id BETWEEN 20001 AND 20020
UNION ALL
SELECT 'photo_customer', COUNT(*) FROM photo_customer WHERE photographer_id BETWEEN 20001 AND 20020
UNION ALL
SELECT 'photo_booking', COUNT(*) FROM photo_booking WHERE photographer_id BETWEEN 20001 AND 20020;

SELECT 'pn_test_001' AS share_code,
       p.id AS photographer_id,
       (SELECT COUNT(*) FROM photo_work w WHERE w.photographer_id = p.id AND w.del_flag = '0') AS work_count,
       (SELECT COUNT(*) FROM photo_package pkg WHERE pkg.photographer_id = p.id AND pkg.del_flag = '0') AS package_count,
       (SELECT COUNT(*) FROM photo_booking b WHERE b.photographer_id = p.id AND b.del_flag = '0') AS booking_count
FROM photo_photographer p
WHERE p.share_code = 'pn_test_001';
