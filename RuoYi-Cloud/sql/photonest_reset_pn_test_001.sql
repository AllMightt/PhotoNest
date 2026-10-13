SET NAMES utf8mb4;

USE `ry-cloud`;

-- PhotoNest 本地联调数据重置脚本
-- 说明：
-- 1. 清理 photo_* 业务表中的全部数据。
-- 2. 仅清理本脚本使用的测试 sys_user，不清空若依系统基础账号、角色、菜单。
-- 3. 主测试入口 share_code 固定为 pn_test_001。
-- 4. 图片 URL 使用本地文件服务 http://localhost:9300/statics/...，方便后台和微信小程序直接预览。

SET FOREIGN_KEY_CHECKS = 0;

DELETE FROM photo_booking;
DELETE FROM photo_customer;
DELETE FROM photo_package_item;
DELETE FROM photo_package;
DELETE FROM photo_work_image;
DELETE FROM photo_work;
DELETE FROM photo_work_category;
DELETE FROM photo_brand_config;
DELETE FROM photo_photographer;

DELETE FROM sys_user_role WHERE user_id BETWEEN 30001 AND 30010;
DELETE FROM sys_user
WHERE user_id BETWEEN 30001 AND 30010
   OR user_name IN ('photo_a', 'photo_b', 'photo_c', 'photo_d', 'photo_e');

SET FOREIGN_KEY_CHECKS = 1;

-- 测试摄影师登录账号，密码均为 admin123。
INSERT INTO sys_user
  (user_id, dept_id, user_name, nick_name, user_type, email, phonenumber, sex, avatar, password, status, del_flag,
   login_ip, login_date, pwd_update_date, create_by, create_time, update_by, update_time, remark)
VALUES
  (30001, 103, 'photo_a', '摄影师A', '00', 'photo_a@example.com', '13800000001', '2', '',
   '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', NOW(), NOW(), 'seed', NOW(), '', NULL, 'PhotoNest pn_test_001 测试摄影师账号'),
  (30002, 103, 'photo_b', '摄影师B', '00', 'photo_b@example.com', '13800000002', '2', '',
   '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', NOW(), NOW(), 'seed', NOW(), '', NULL, 'PhotoNest 数据隔离测试摄影师账号'),
  (30003, 103, 'photo_c', '摄影师C', '00', 'photo_c@example.com', '13800000003', '2', '',
   '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', NOW(), NOW(), 'seed', NOW(), '', NULL, 'PhotoNest 后台分页测试摄影师账号'),
  (30004, 103, 'photo_d', '摄影师D', '00', 'photo_d@example.com', '13800000004', '2', '',
   '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', NOW(), NOW(), 'seed', NOW(), '', NULL, 'PhotoNest 后台分页测试摄影师账号'),
  (30005, 103, 'photo_e', '摄影师E', '00', 'photo_e@example.com', '13800000005', '2', '',
   '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', NOW(), NOW(), 'seed', NOW(), '', NULL, 'PhotoNest 停用摄影师测试账号');

INSERT INTO sys_user_role (user_id, role_id) VALUES
  (30001, 2),
  (30002, 2),
  (30003, 2),
  (30004, 2),
  (30005, 2);

INSERT INTO photo_photographer
  (id, user_id, brand_name, photographer_name, share_code, avatar, cover_image, city, phone, wechat_id, wechat_qr,
   xiaohongshu_id, xiaohongshu_qr, douyin_id, douyin_qr, status, plan_type, expire_time, storage_limit, storage_used,
   work_limit, package_limit, create_by, create_time, update_by, update_time, remark, del_flag)
VALUES
  (20001, 30001, '树下摄影', '测试摄影师01', 'pn_test_001',
   'http://localhost:9300/statics/2026/06/05/IMG_5846_20260605145747A002.jpg',
   'http://localhost:9300/statics/2026/06/05/26.05.04_黄陂婚礼_口播_20260605145747A003.jpg',
   '上海', '13800000001', 'photo_demo_001', '', 'shuxia_photo', '', 'shuxia_photo', '',
   '0', 'pro', DATE_ADD(NOW(), INTERVAL 365 DAY), 10737418240, 536870912, 200, 50, 'seed', NOW(), 'seed', NOW(), '主测试摄影师', '0'),
  (20002, 30002, '海盐影像', '测试摄影师02', 'pn_demo_002',
   'http://localhost:9300/statics/2026/06/05/IMG_6921_20260605145747A004.jpg',
   'http://localhost:9300/statics/2026/06/05/Xnip2026-05-13_21-27-59_20260605100801A001.jpg',
   '杭州', '13800000002', 'photo_demo_002', '', 'haiyan_photo', '', 'haiyan_photo', '',
   '0', 'free', DATE_ADD(NOW(), INTERVAL 90 DAY), 2147483648, 104857600, 100, 20, 'seed', NOW(), 'seed', NOW(), '数据隔离测试摄影师', '0'),
  (20003, 30003, '南风纪实', '测试摄影师03', 'pn_demo_003',
   'http://localhost:9300/statics/2026/06/05/IMG_6921_20260605154224A005.jpg',
   'http://localhost:9300/statics/2026/06/05/IMG_6960_20260605154252A006.jpg',
   '苏州', '13800000003', 'photo_demo_003', '', 'nanfeng_photo', '', 'nanfeng_photo', '',
   '0', 'free', DATE_ADD(NOW(), INTERVAL 120 DAY), 2147483648, 73400320, 100, 20, 'seed', NOW(), 'seed', NOW(), '后台筛选测试摄影师', '0'),
  (20004, 30004, '白日梦摄影', '测试摄影师04', 'pn_demo_004',
   'http://localhost:9300/statics/2026/06/05/IMG_6960_20260605214049A007.jpg',
   'http://localhost:9300/statics/2026/06/05/IMG_6921_20260605214059A008.jpg',
   '成都', '13800000004', 'photo_demo_004', '', 'daydream_photo', '', 'daydream_photo', '',
   '0', 'pro', DATE_ADD(NOW(), INTERVAL 180 DAY), 5368709120, 209715200, 150, 30, 'seed', NOW(), 'seed', NOW(), '后台分页测试摄影师', '0'),
  (20005, 30005, '停用测试摄影师', '测试摄影师05', 'pn_demo_disabled',
   'http://localhost:9300/statics/2026/06/05/Xnip2026-05-13_21-27-59_20260605100843A004.jpg',
   'http://localhost:9300/statics/2026/06/05/IMG_5846_20260605145747A002.jpg',
   '深圳', '13800000005', 'photo_demo_005', '', 'disabled_photo', '', 'disabled_photo', '',
   '1', 'free', DATE_ADD(NOW(), INTERVAL 30 DAY), 2147483648, 0, 50, 10, 'seed', NOW(), 'seed', NOW(), '停用状态测试摄影师', '0');

INSERT INTO photo_brand_config
  (id, photographer_id, brand_name, photographer_name, logo_url, cover_image, subtitle, intro, about_content, city,
   phone, wechat_id, wechat_qr, xiaohongshu_id, xiaohongshu_qr, douyin_id, douyin_qr, shoot_process, faq_content,
   status, create_by, create_time, update_by, update_time, remark, del_flag)
VALUES
  (22001, 20001, '树下摄影', '测试摄影师01',
   'http://localhost:9300/statics/2026/06/05/IMG_5846_20260605145747A002.jpg',
   'http://localhost:9300/statics/2026/06/05/26.05.04_黄陂婚礼_口播_20260605145747A003.jpg',
   'photography studio',
   '摄影有温度的照片，记录平凡生活中的美好。每一次快门，都是一瞬间的精彩。',
   '我们专注婚礼纪实、领证跟拍、写真与亲子家庭影像。拍摄前会认真沟通人物关系、场地光线和当天节奏，尽量把真实情绪、细节动作和现场氛围留下来。第一版测试数据包含足量作品、套系和预约，便于在后台与微信小程序中验证完整流程。',
   '上海', '13800000001', 'photo_demo_001', '', 'shuxia_photo', '', 'shuxia_photo', '',
   '需求沟通 -> 确认拍摄方向 -> 预约咨询 -> 拍摄执行 -> 初筛调色 -> 精修交付',
   'Q: 可以先咨询档期吗？A: 可以，提交预约后摄影师会人工确认。Q: 档期冲突会怎样？A: 客户端不阻止提交，摄影师会联系客户沟通替代时间。',
   '0', 'seed', NOW(), 'seed', NOW(), 'pn_test_001 主页、关于、联系方式测试配置', '0'),
  (22002, 20002, '海盐影像', '测试摄影师02',
   'http://localhost:9300/statics/2026/06/05/IMG_6921_20260605145747A004.jpg',
   'http://localhost:9300/statics/2026/06/05/Xnip2026-05-13_21-27-59_20260605100801A001.jpg',
   'soft light documentary', '杭州本地纪实摄影，偏自然光与情绪记录。',
   '用于验证摄影师 B 的数据隔离，A 摄影师不应看到或修改 B 摄影师的数据。',
   '杭州', '13800000002', 'photo_demo_002', '', 'haiyan_photo', '', 'haiyan_photo', '',
   '沟通 -> 预约 -> 拍摄 -> 交付', '摄影师 B FAQ', '0', 'seed', NOW(), 'seed', NOW(), '隔离测试配置', '0'),
  (22003, 20003, '南风纪实', '测试摄影师03',
   'http://localhost:9300/statics/2026/06/05/IMG_6921_20260605154224A005.jpg',
   'http://localhost:9300/statics/2026/06/05/IMG_6960_20260605154252A006.jpg',
   'wedding story', '苏州婚礼与订婚纪实摄影。',
   '后台分页和筛选测试数据。', '苏州', '13800000003', 'photo_demo_003', '', 'nanfeng_photo', '', 'nanfeng_photo', '',
   '沟通 -> 拍摄 -> 交付', '摄影师 C FAQ', '0', 'seed', NOW(), 'seed', NOW(), '后台筛选测试配置', '0'),
  (22004, 20004, '白日梦摄影', '测试摄影师04',
   'http://localhost:9300/statics/2026/06/05/IMG_6960_20260605214049A007.jpg',
   'http://localhost:9300/statics/2026/06/05/IMG_6921_20260605214059A008.jpg',
   'family memories', '成都亲子家庭与写真摄影。',
   '后台分页测试数据。', '成都', '13800000004', 'photo_demo_004', '', 'daydream_photo', '', 'daydream_photo', '',
   '沟通 -> 拍摄 -> 交付', '摄影师 D FAQ', '0', 'seed', NOW(), 'seed', NOW(), '后台分页测试配置', '0'),
  (22005, 20005, '停用摄影师主页', '测试摄影师05',
   'http://localhost:9300/statics/2026/06/05/Xnip2026-05-13_21-27-59_20260605100843A004.jpg',
   'http://localhost:9300/statics/2026/06/05/IMG_5846_20260605145747A002.jpg',
   'disabled demo', '停用摄影师配置。',
   '用于测试停用摄影师。', '深圳', '13800000005', 'photo_demo_005', '', 'disabled_photo', '', 'disabled_photo', '',
   '无', '无', '1', 'seed', NOW(), 'seed', NOW(), '停用测试配置', '0');

INSERT INTO photo_work_category
  (id, photographer_id, category_name, category_icon, sort, status, create_by, create_time, update_by, update_time, remark, del_flag)
VALUES
  (210001, 20001, '婚礼纪实', '', 1, '0', 'seed', NOW(), 'seed', NOW(), '小程序作品 Tab 分类排序测试', '0'),
  (210002, 20001, '领证跟拍', '', 2, '0', 'seed', NOW(), 'seed', NOW(), '小程序作品 Tab 分类排序测试', '0'),
  (210003, 20001, '个人写真', '', 3, '0', 'seed', NOW(), 'seed', NOW(), '小程序作品 Tab 分类排序测试', '0'),
  (210004, 20001, '亲子家庭', '', 4, '0', 'seed', NOW(), 'seed', NOW(), '小程序作品 Tab 分类排序测试', '0'),
  (210005, 20001, '订婚仪式', '', 5, '0', 'seed', NOW(), 'seed', NOW(), '小程序作品 Tab 分类排序测试', '0'),
  (210006, 20001, '商业活动', '', 6, '0', 'seed', NOW(), 'seed', NOW(), '小程序作品 Tab 分类 MORE 测试', '0'),
  (210007, 20001, '家庭纪实', '', 7, '0', 'seed', NOW(), 'seed', NOW(), '小程序作品 Tab 分类 MORE 测试', '0'),
  (210008, 20001, '儿童写真', '', 8, '0', 'seed', NOW(), 'seed', NOW(), '小程序作品 Tab 分类 MORE 测试', '0'),
  (210009, 20001, '孕妈写真', '', 9, '0', 'seed', NOW(), 'seed', NOW(), '小程序作品 Tab 分类 MORE 测试', '0'),
  (210010, 20001, '毕业季', '', 10, '0', 'seed', NOW(), 'seed', NOW(), '小程序作品 Tab 分类 MORE 测试', '0'),
  (210011, 20001, '情侣写真', '', 11, '0', 'seed', NOW(), 'seed', NOW(), '小程序作品 Tab 分类 MORE 测试', '0'),
  (210012, 20001, '闺蜜写真', '', 12, '0', 'seed', NOW(), 'seed', NOW(), '小程序作品 Tab 默认展示第12个分类', '0'),
  (210013, 20001, '肖像写真', '', 13, '0', 'seed', NOW(), 'seed', NOW(), '小程序作品 Tab 点击 MORE 后展示', '0'),
  (210014, 20001, '城市旅拍', '', 14, '0', 'seed', NOW(), 'seed', NOW(), '小程序作品 Tab 点击 MORE 后展示', '0'),
  (210015, 20001, '宠物写真', '', 15, '0', 'seed', NOW(), 'seed', NOW(), '小程序作品 Tab 点击 MORE 后展示', '0'),
  (210016, 20001, '停用分类', '', 99, '1', 'seed', NOW(), 'seed', NOW(), '小程序不应展示该分类', '0'),
  (210021, 20002, '婚礼纪实', '', 1, '0', 'seed', NOW(), 'seed', NOW(), '摄影师B分类', '0'),
  (210022, 20002, '写真', '', 2, '0', 'seed', NOW(), 'seed', NOW(), '摄影师B分类', '0'),
  (210031, 20003, '婚礼纪实', '', 1, '0', 'seed', NOW(), 'seed', NOW(), '摄影师C分类', '0'),
  (210041, 20004, '亲子家庭', '', 1, '0', 'seed', NOW(), 'seed', NOW(), '摄影师D分类', '0');

DELIMITER $$

DROP PROCEDURE IF EXISTS seed_photonest_pn_test_001 $$
CREATE PROCEDURE seed_photonest_pn_test_001()
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE j INT DEFAULT 1;
  DECLARE work_status CHAR(1);
  DECLARE package_status CHAR(1);
  DECLARE image_url VARCHAR(500);
  DECLARE category_id BIGINT;
  DECLARE shoot_type_value VARCHAR(50);
  DECLARE price_type_value VARCHAR(20);
  DECLARE source_channel_value VARCHAR(50);
  DECLARE source_page_value VARCHAR(100);

  WHILE i <= 36 DO
    SET image_url = ELT(((i - 1) MOD 8) + 1,
      'http://localhost:9300/statics/2026/06/05/26.05.04_黄陂婚礼_口播_20260605145747A003.jpg',
      'http://localhost:9300/statics/2026/06/05/IMG_5846_20260605145747A002.jpg',
      'http://localhost:9300/statics/2026/06/05/IMG_6921_20260605145747A004.jpg',
      'http://localhost:9300/statics/2026/06/05/IMG_6921_20260605154224A005.jpg',
      'http://localhost:9300/statics/2026/06/05/IMG_6960_20260605154252A006.jpg',
      'http://localhost:9300/statics/2026/06/05/IMG_6960_20260605214049A007.jpg',
      'http://localhost:9300/statics/2026/06/05/IMG_6921_20260605214059A008.jpg',
      'http://localhost:9300/statics/2026/06/05/Xnip2026-05-13_21-27-59_20260605100801A001.jpg'
    );
    SET category_id = 210000 + (((i - 1) MOD 5) + 1);
    SET shoot_type_value = ELT(((i - 1) MOD 6) + 1, '写真', '领证', '百天', '周岁', '婚礼', '订婚');
    SET work_status = CASE
      WHEN i <= 28 THEN '0'
      WHEN i <= 32 THEN '1'
      ELSE '2'
    END;

    INSERT INTO photo_work
      (id, photographer_id, category_id, title, cover_url, tags, shoot_type, shoot_location, shoot_time, description,
       is_home_recommend, publish_time, sort, view_count, status, create_by, create_time, update_by, update_time, remark, del_flag)
    VALUES
      (231000 + i, 20001, IF(i = 36, 210006, category_id),
       CONCAT(ELT(((i - 1) MOD 5) + 1, '拍摄于上海外滩', '拍摄于武康路', '拍摄于山水富丽华酒店', '拍摄于湖锦酒店', '拍摄于城市花园'), '-', LPAD(i, 2, '0')),
       image_url,
       CONCAT('#作品欣赏,#', shoot_type_value, ',#PhotoNest测试'),
       shoot_type_value,
       ELT(((i - 1) MOD 6) + 1, '上海外滩', '武康路街区', '山水富丽华酒店', '湖锦酒店', '城市花园', '室内自然光棚'),
       DATE_SUB(NOW(), INTERVAL (40 - i) DAY),
       CONCAT('pn_test_001 作品组第 ', i, ' 组，用于测试作品集封面、作品详情组图、分页、最近发布排序和上下架展示。'),
       IF(i <= 8, '1', '0'),
       DATE_SUB(NOW(), INTERVAL (36 - i) HOUR),
       i,
       1000 + i * 17,
       work_status,
       'seed', NOW(), 'seed', NOW(),
       CASE work_status WHEN '0' THEN '已发布作品，小程序可见' WHEN '1' THEN '下架作品，仅后台测试' ELSE '草稿作品，仅后台测试' END,
       '0');

    SET j = 1;
    WHILE j <= 4 DO
      SET image_url = ELT(((i + j - 2) MOD 8) + 1,
        'http://localhost:9300/statics/2026/06/05/26.05.04_黄陂婚礼_口播_20260605145747A003.jpg',
        'http://localhost:9300/statics/2026/06/05/IMG_5846_20260605145747A002.jpg',
        'http://localhost:9300/statics/2026/06/05/IMG_6921_20260605145747A004.jpg',
        'http://localhost:9300/statics/2026/06/05/IMG_6921_20260605154224A005.jpg',
        'http://localhost:9300/statics/2026/06/05/IMG_6960_20260605154252A006.jpg',
        'http://localhost:9300/statics/2026/06/05/IMG_6960_20260605214049A007.jpg',
        'http://localhost:9300/statics/2026/06/05/IMG_6921_20260605214059A008.jpg',
        'http://localhost:9300/statics/2026/06/05/Xnip2026-05-13_21-27-59_20260605100801A001.jpg'
      );

      INSERT INTO photo_work_image
        (id, photographer_id, work_id, original_url, display_url, thumbnail_url, watermark_url, file_name, file_size,
         width, height, sort, status, create_by, create_time, update_by, update_time, remark, del_flag)
      VALUES
        (241000 + i * 10 + j, 20001, 231000 + i,
         image_url, image_url, image_url, image_url,
         CONCAT('pn-test-work-', LPAD(i, 2, '0'), '-', j, '.jpg'),
         900000 + i * 10000 + j * 1000,
         IF(j = 1, 3024, 1600), IF(j = 1, 4032, 2400), j,
         IF(i = 10 AND j = 4, '1', '0'),
         'seed', NOW(), 'seed', NOW(),
         IF(i = 10 AND j = 4, '隐藏图片，小程序详情不应展示', '作品详情组图测试图片'),
         '0');

      SET j = j + 1;
    END WHILE;

    SET i = i + 1;
  END WHILE;

  -- 给默认分类“婚礼纪实”额外补足已发布作品，让作品 Tab 能测试：
  -- 默认显示12条；超过12条显示 MORE；点击 MORE 后展示剩余全部。
  SET i = 1;
  WHILE i <= 8 DO
    SET image_url = ELT(((i - 1) MOD 8) + 1,
      'http://localhost:9300/statics/2026/06/05/26.05.04_黄陂婚礼_口播_20260605145747A003.jpg',
      'http://localhost:9300/statics/2026/06/05/IMG_5846_20260605145747A002.jpg',
      'http://localhost:9300/statics/2026/06/05/IMG_6921_20260605145747A004.jpg',
      'http://localhost:9300/statics/2026/06/05/IMG_6921_20260605154224A005.jpg',
      'http://localhost:9300/statics/2026/06/05/IMG_6960_20260605154252A006.jpg',
      'http://localhost:9300/statics/2026/06/05/IMG_6960_20260605214049A007.jpg',
      'http://localhost:9300/statics/2026/06/05/IMG_6921_20260605214059A008.jpg',
      'http://localhost:9300/statics/2026/06/05/Xnip2026-05-13_21-27-59_20260605100801A001.jpg'
    );

    INSERT INTO photo_work
      (id, photographer_id, category_id, title, cover_url, tags, shoot_type, shoot_location, shoot_time, description,
       is_home_recommend, publish_time, sort, view_count, status, create_by, create_time, update_by, update_time, remark, del_flag)
    VALUES
      (233000 + i, 20001, 210001,
       CONCAT('婚礼纪实 MORE 测试-', LPAD(i, 2, '0')),
       image_url,
       '#作品欣赏,#婚礼,#MORE测试',
       '婚礼',
       ELT(((i - 1) MOD 4) + 1, '上海外滩', '山水富丽华酒店', '湖锦酒店', '城市花园'),
       DATE_SUB(NOW(), INTERVAL i DAY),
       CONCAT('婚礼纪实分类额外已发布作品第 ', i, ' 条，用于验证小程序作品 Tab 默认12条与 MORE 展开全部。'),
       '0',
       DATE_ADD(NOW(), INTERVAL i HOUR),
       100 + i,
       3000 + i,
       '0',
       'seed', NOW(), 'seed', NOW(),
       '婚礼纪实 MORE 测试作品，小程序可见',
       '0');

    SET j = 1;
    WHILE j <= 3 DO
      INSERT INTO photo_work_image
        (id, photographer_id, work_id, original_url, display_url, thumbnail_url, watermark_url, file_name, file_size,
         width, height, sort, status, create_by, create_time, update_by, update_time, remark, del_flag)
      VALUES
        (243000 + i * 10 + j, 20001, 233000 + i,
         image_url, image_url, image_url, image_url,
         CONCAT('pn-test-wedding-more-', LPAD(i, 2, '0'), '-', j, '.jpg'),
         1200000 + i * 10000 + j * 1000,
         1600, 2400, j, '0', 'seed', NOW(), 'seed', NOW(), '婚礼纪实 MORE 测试图片', '0');
      SET j = j + 1;
    END WHILE;

    SET i = i + 1;
  END WHILE;

  SET i = 1;
  WHILE i <= 24 DO
    SET image_url = ELT(((i - 1) MOD 8) + 1,
      'http://localhost:9300/statics/2026/06/05/IMG_5846_20260605145747A002.jpg',
      'http://localhost:9300/statics/2026/06/05/IMG_6921_20260605145747A004.jpg',
      'http://localhost:9300/statics/2026/06/05/IMG_6960_20260605154252A006.jpg',
      'http://localhost:9300/statics/2026/06/05/Xnip2026-05-13_21-27-59_20260605100801A001.jpg',
      'http://localhost:9300/statics/2026/06/05/26.05.04_黄陂婚礼_口播_20260605145747A003.jpg',
      'http://localhost:9300/statics/2026/06/05/IMG_6921_20260605154224A005.jpg',
      'http://localhost:9300/statics/2026/06/05/IMG_6921_20260605214059A008.jpg',
      'http://localhost:9300/statics/2026/06/05/IMG_6960_20260605214049A007.jpg'
    );
    SET shoot_type_value = ELT(((i - 1) MOD 6) + 1, '写真', '领证', '百天', '周岁', '婚礼', '订婚');
    SET price_type_value = ELT(((i - 1) MOD 4) + 1, 'public', 'from', 'negotiable', 'hidden');
    SET package_status = CASE
      WHEN i <= 18 THEN '0'
      WHEN i <= 21 THEN '1'
      ELSE '2'
    END;

    INSERT INTO photo_package
      (id, photographer_id, package_name, cover_url, price_display_type, price_text, price, deposit_amount,
       duration_minutes, original_photo_count, retouch_photo_count, suitable_people, service_content, delivery_cycle,
       extra_photo_price, extra_hour_price, notice, reschedule_rule, sort, status, create_by, create_time, update_by,
       update_time, remark, del_flag)
    VALUES
      (251000 + i, 20001, CONCAT(shoot_type_value, '拍摄套系 ', LPAD(i, 2, '0')), image_url, price_type_value,
       CASE price_type_value
         WHEN 'public' THEN CONCAT('¥', 999 + i * 120)
         WHEN 'from' THEN CONCAT('¥', 699 + i * 80, ' 起')
         WHEN 'negotiable' THEN '价格面议'
         ELSE '私信咨询'
       END,
       IF(price_type_value IN ('public', 'from'), 999 + i * 120, NULL),
       IF(price_type_value IN ('public', 'from'), 200 + i * 20, NULL),
       60 + i * 10,
       50 + i * 5,
       6 + (i MOD 6),
       CONCAT('适合', shoot_type_value, '客户、情侣、家庭和婚礼新人'),
       CONCAT('包含前期沟通、', shoot_type_value, '拍摄、基础调色、精选精修与云端交付。'),
       ELT(((i - 1) MOD 3) + 1, '7天内交付', '10天内交付', '14天内交付'),
       80.00 + i,
       180.00 + i * 5,
       '预约咨询不等于确认档期，最终时间由摄影师人工沟通确认。',
       '拍摄前48小时可免费协调一次，特殊天气可协商改期。',
       i,
       package_status,
       'seed', NOW(), 'seed', NOW(),
       CASE package_status WHEN '0' THEN '上架套系，小程序可见' WHEN '1' THEN '下架套系，仅后台测试' ELSE '草稿套系，仅后台测试' END,
       '0');

    SET j = 1;
    WHILE j <= 5 DO
      INSERT INTO photo_package_item
        (id, photographer_id, package_id, item_name, item_value, sort, create_by, create_time, update_by, update_time, remark, del_flag)
      VALUES
        (261000 + i * 10 + j, 20001, 251000 + i,
         ELT(j, '拍摄时长', '底片数量', '精修数量', '服务内容', '交付方式'),
         ELT(j,
           CONCAT(60 + i * 10, '分钟'),
           CONCAT(50 + i * 5, '张起'),
           CONCAT(6 + (i MOD 6), '张'),
           CONCAT(shoot_type_value, '拍摄、基础调色、简单修瑕'),
           '网盘/小程序相册交付'),
         j, 'seed', NOW(), 'seed', NOW(), '套系详情明细测试', '0');
      SET j = j + 1;
    END WHILE;

    SET i = i + 1;
  END WHILE;

  SET i = 1;
  WHILE i <= 30 DO
    INSERT INTO photo_customer
      (id, photographer_id, openid, nickname, avatar_url, real_name, phone, wechat_id, status,
       create_by, create_time, update_by, update_time, remark, del_flag)
    VALUES
      (271000 + i, 20001,
       IF(i IN (29, 30), NULL, CONCAT('openid_pn_test_001_', LPAD(i, 2, '0'))),
       CONCAT('客户昵称', LPAD(i, 2, '0')),
       'http://localhost:9300/statics/2026/06/05/IMG_5846_20260605145747A002.jpg',
       CONCAT('测试客户', LPAD(i, 2, '0')),
       CONCAT('1390000', LPAD(i, 4, '0')),
       CONCAT('client_wechat_', LPAD(i, 2, '0')),
       IF(i = 30, '1', '0'),
       'seed', NOW(), 'seed', NOW(), IF(i >= 29, 'openid 为空客户，用于辅助识别测试', '客户分页测试数据'), '0');

    SET i = i + 1;
  END WHILE;

  SET i = 1;
  WHILE i <= 40 DO
    SET shoot_type_value = ELT(((i - 1) MOD 6) + 1, '写真', '领证', '百天', '周岁', '婚礼', '订婚');
    SET source_channel_value = ELT(((i - 1) MOD 5) + 1, 'xiaohongshu', 'douyin', 'wechat', 'friend_circle', 'manual_share');
    SET source_page_value = ELT(((i - 1) MOD 4) + 1, 'home', 'work-detail', 'package-detail', 'about');

    INSERT INTO photo_booking
      (id, photographer_id, customer_id, booking_no, customer_name, phone, wechat_id, shoot_type, package_id,
       expected_date, expected_time, expected_location, people_count, has_child, requirement, source_channel,
       source_page, source_type, source_work_id, source_package_id, status, create_by, create_time, update_by,
       update_time, remark, del_flag)
    VALUES
      (281000 + i, 20001, 271000 + (((i - 1) MOD 30) + 1),
       CONCAT('PNTEST001-', DATE_FORMAT(NOW(), '%Y%m%d'), '-', LPAD(i, 4, '0')),
       CONCAT('测试客户', LPAD(((i - 1) MOD 30) + 1, 2, '0')),
       CONCAT('1390000', LPAD(((i - 1) MOD 30) + 1, 4, '0')),
       CONCAT('client_wechat_', LPAD(((i - 1) MOD 30) + 1, 2, '0')),
       shoot_type_value,
       IF(i MOD 3 = 0, 251000 + (((i - 1) MOD 18) + 1), NULL),
       DATE_ADD(CURDATE(), INTERVAL (i + 1) DAY),
       ELT(((i - 1) MOD 5) + 1, '上午 9 点到 12 点', '下午 2 点以后', '晚上 6 点左右', '周末都可以', '婚礼当天全程'),
       ELT(((i - 1) MOD 5) + 1, '上海外滩', '武康路', '客户自选地点', '酒店宴会厅', '民政局附近'),
       1 + (i MOD 6),
       IF(i MOD 4 = 0, '1', '0'),
       CONCAT('客户希望咨询', shoot_type_value, '拍摄，日期和时间段由客户自行填写，档期由摄影师后续人工确认。'),
       source_channel_value,
       source_page_value,
       CASE source_page_value WHEN 'work-detail' THEN 'work' WHEN 'package-detail' THEN 'package' ELSE 'page' END,
       IF(source_page_value = 'work-detail', 231000 + (((i - 1) MOD 28) + 1), NULL),
       IF(source_page_value = 'package-detail', 251000 + (((i - 1) MOD 18) + 1), NULL),
       CAST(((i - 1) MOD 5) AS CHAR),
       'seed',
       DATE_SUB(NOW(), INTERVAL (40 - i) HOUR),
       'seed', NOW(),
       '预约咨询分页、状态、来源渠道测试数据',
       '0');

    SET i = i + 1;
  END WHILE;

  -- 其他摄影师少量数据，用于平台后台筛选、摄影师数据隔离。
  SET i = 2;
  WHILE i <= 4 DO
    SET category_id = CASE i WHEN 2 THEN 210021 WHEN 3 THEN 210031 ELSE 210041 END;
    SET j = 1;
    WHILE j <= 6 DO
      SET image_url = ELT(((i + j - 2) MOD 8) + 1,
        'http://localhost:9300/statics/2026/06/05/IMG_5846_20260605145747A002.jpg',
        'http://localhost:9300/statics/2026/06/05/IMG_6921_20260605145747A004.jpg',
        'http://localhost:9300/statics/2026/06/05/IMG_6960_20260605154252A006.jpg',
        'http://localhost:9300/statics/2026/06/05/Xnip2026-05-13_21-27-59_20260605100801A001.jpg',
        'http://localhost:9300/statics/2026/06/05/26.05.04_黄陂婚礼_口播_20260605145747A003.jpg',
        'http://localhost:9300/statics/2026/06/05/IMG_6921_20260605154224A005.jpg',
        'http://localhost:9300/statics/2026/06/05/IMG_6921_20260605214059A008.jpg',
        'http://localhost:9300/statics/2026/06/05/IMG_6960_20260605214049A007.jpg'
      );

      INSERT INTO photo_work
        (id, photographer_id, category_id, title, cover_url, tags, shoot_type, shoot_location, shoot_time, description,
         is_home_recommend, publish_time, sort, view_count, status, create_by, create_time, update_by, update_time, remark, del_flag)
      VALUES
        (232000 + i * 100 + j, 20000 + i, category_id, CONCAT('隔离测试作品 P', i, '-', j), image_url,
         '#隔离测试,#作品欣赏', '写真', '测试城市', DATE_SUB(NOW(), INTERVAL j DAY),
         CONCAT('摄影师 ', i, ' 的隔离测试作品。'), IF(j <= 2, '1', '0'), DATE_SUB(NOW(), INTERVAL j HOUR),
         j, j * 20, IF(j = 6, '1', '0'), 'seed', NOW(), 'seed', NOW(), '其他摄影师隔离测试作品', '0');

      INSERT INTO photo_work_image
        (id, photographer_id, work_id, original_url, display_url, thumbnail_url, watermark_url, file_name, file_size,
         width, height, sort, status, create_by, create_time, update_by, update_time, remark, del_flag)
      VALUES
        (242000 + i * 100 + j, 20000 + i, 232000 + i * 100 + j,
         image_url, image_url, image_url, image_url, CONCAT('isolate-', i, '-', j, '.jpg'),
         888000 + j * 1000, 1600, 2400, 1, '0', 'seed', NOW(), 'seed', NOW(), '其他摄影师作品图片', '0');

      INSERT INTO photo_package
        (id, photographer_id, package_name, cover_url, price_display_type, price_text, price, deposit_amount,
         duration_minutes, original_photo_count, retouch_photo_count, suitable_people, service_content, delivery_cycle,
         extra_photo_price, extra_hour_price, notice, reschedule_rule, sort, status, create_by, create_time, update_by,
         update_time, remark, del_flag)
      VALUES
        (252000 + i * 100 + j, 20000 + i, CONCAT('隔离测试套系 P', i, '-', j), image_url, 'public',
         CONCAT('¥', 899 + j * 100), 899 + j * 100, 200.00, 90, 60, 8, '隔离测试客户',
         '其他摄影师套系，用于验证数据隔离。', '7天内交付', 80.00, 180.00, '请提前沟通。', '可协调改期。',
         j, IF(j = 6, '1', '0'), 'seed', NOW(), 'seed', NOW(), '其他摄影师隔离测试套系', '0');

      INSERT INTO photo_package_item
        (id, photographer_id, package_id, item_name, item_value, sort, create_by, create_time, update_by, update_time, remark, del_flag)
      VALUES
        (262000 + i * 100 + j, 20000 + i, 252000 + i * 100 + j, '服务内容', '隔离测试套系明细', 1, 'seed', NOW(), 'seed', NOW(), '隔离测试', '0');

      INSERT INTO photo_customer
        (id, photographer_id, openid, nickname, avatar_url, real_name, phone, wechat_id, status,
         create_by, create_time, update_by, update_time, remark, del_flag)
      VALUES
        (272000 + i * 100 + j, 20000 + i, CONCAT('openid_demo_', i, '_', j), CONCAT('隔离客户', i, j), '',
         CONCAT('隔离客户', i, j), CONCAT('137', LPAD(i, 4, '0'), LPAD(j, 4, '0')), CONCAT('isolate_client_', i, '_', j),
         '0', 'seed', NOW(), 'seed', NOW(), '隔离测试客户', '0');

      INSERT INTO photo_booking
        (id, photographer_id, customer_id, booking_no, customer_name, phone, wechat_id, shoot_type, package_id,
         expected_date, expected_time, expected_location, people_count, has_child, requirement, source_channel,
         source_page, source_type, source_work_id, source_package_id, status, create_by, create_time, update_by,
         update_time, remark, del_flag)
      VALUES
        (282000 + i * 100 + j, 20000 + i, 272000 + i * 100 + j, CONCAT('PN-DEMO-', i, '-', LPAD(j, 3, '0')),
         CONCAT('隔离客户', i, j), CONCAT('137', LPAD(i, 4, '0'), LPAD(j, 4, '0')), CONCAT('isolate_client_', i, '_', j),
         '写真', 252000 + i * 100 + j, DATE_ADD(CURDATE(), INTERVAL j DAY), '下午 3 点以后',
         '测试地点', 2, '0', '其他摄影师预约，A 摄影师不应访问。', 'wechat', 'package-detail', 'package',
         NULL, 252000 + i * 100 + j, CAST(((j - 1) MOD 5) AS CHAR), 'seed', NOW(), 'seed', NOW(), '隔离测试预约', '0');

      SET j = j + 1;
    END WHILE;

    SET i = i + 1;
  END WHILE;
END $$

DELIMITER ;

CALL seed_photonest_pn_test_001();

DROP PROCEDURE IF EXISTS seed_photonest_pn_test_001;

SELECT 'photo_photographer' AS table_name, COUNT(*) AS total FROM photo_photographer
UNION ALL SELECT 'photo_brand_config', COUNT(*) FROM photo_brand_config
UNION ALL SELECT 'photo_work_category', COUNT(*) FROM photo_work_category
UNION ALL SELECT 'photo_work', COUNT(*) FROM photo_work
UNION ALL SELECT 'photo_work_image', COUNT(*) FROM photo_work_image
UNION ALL SELECT 'photo_package', COUNT(*) FROM photo_package
UNION ALL SELECT 'photo_package_item', COUNT(*) FROM photo_package_item
UNION ALL SELECT 'photo_customer', COUNT(*) FROM photo_customer
UNION ALL SELECT 'photo_booking', COUNT(*) FROM photo_booking;

SELECT status, COUNT(*) AS work_count
FROM photo_work
WHERE photographer_id = 20001
GROUP BY status
ORDER BY status;

SELECT status, COUNT(*) AS package_count
FROM photo_package
WHERE photographer_id = 20001
GROUP BY status
ORDER BY status;
