SET NAMES utf8mb4;

-- ----------------------------
-- PhotoNest MVP 数据表
-- ----------------------------

-- ----------------------------
-- 1、摄影师账号/租户主体表
-- ----------------------------
drop table if exists photo_photographer;
create table photo_photographer (
  id                bigint(20)      not null auto_increment    comment '摄影师ID',
  user_id           bigint(20)      default null               comment '关联系统用户ID',
  brand_name        varchar(100)    default ''                 comment '品牌名称',
  photographer_name varchar(50)     default ''                 comment '摄影师姓名',
  share_code        varchar(64)     not null                   comment '分享码，用于客户访问摄影师主页',
  avatar            varchar(500)    default ''                 comment '头像地址',
  cover_image       varchar(500)    default ''                 comment '主页封面图',
  city              varchar(50)     default ''                 comment '所在城市',
  phone             varchar(20)     default ''                 comment '联系电话',
  wechat_id         varchar(100)    default ''                 comment '微信号',
  wechat_qr         varchar(500)    default ''                 comment '微信二维码',
  xiaohongshu_id    varchar(100)    default ''                 comment '小红书号',
  xiaohongshu_qr    varchar(500)    default ''                 comment '小红书二维码',
  douyin_id         varchar(100)    default ''                 comment '抖音号',
  douyin_qr         varchar(500)    default ''                 comment '抖音二维码',
  status            char(1)         default '0'                comment '状态（0正常 1停用）',
  plan_type         varchar(20)     default 'free'             comment '套餐类型（free免费版 pro专业版）',
  expire_time       datetime                                   comment '到期时间',
  storage_limit     bigint(20)      default 2147483648         comment '存储空间限制，单位字节',
  storage_used      bigint(20)      default 0                  comment '已用存储空间，单位字节',
  work_limit        int(11)         default 100                comment '作品数量限制',
  package_limit     int(11)         default 20                 comment '套系数量限制',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default null               comment '备注',
  del_flag          char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  primary key (id),
  unique key uk_photo_photographer_share_code (share_code),
  unique key uk_photo_photographer_user_id (user_id),
  key idx_photo_photographer_status (status),
  key idx_photo_photographer_city (city)
) engine=innodb default charset=utf8mb4 collate=utf8mb4_general_ci comment = 'PhotoNest摄影师账号/租户主体表';

-- ----------------------------
-- 2、摄影师品牌主页配置表
-- ----------------------------
drop table if exists photo_brand_config;
create table photo_brand_config (
  id                bigint(20)      not null auto_increment    comment '品牌配置ID',
  photographer_id   bigint(20)      not null                   comment '摄影师ID',
  brand_name        varchar(100)    default ''                 comment '品牌名称',
  photographer_name varchar(50)     default ''                 comment '摄影师姓名',
  logo_url          varchar(500)    default ''                 comment 'Logo地址',
  cover_image       varchar(500)    default ''                 comment '首页主视觉图片',
  subtitle          varchar(200)    default ''                 comment '英文副标题/品牌副标题',
  intro             varchar(1000)   default ''                 comment '摄影师简介',
  about_content     text                                      comment '关于页完整介绍',
  city              varchar(50)     default ''                 comment '服务城市',
  phone             varchar(20)     default ''                 comment '联系电话',
  wechat_id         varchar(100)    default ''                 comment '微信号',
  wechat_qr         varchar(500)    default ''                 comment '微信二维码',
  xiaohongshu_id    varchar(100)    default ''                 comment '小红书号',
  xiaohongshu_qr    varchar(500)    default ''                 comment '小红书二维码',
  douyin_id         varchar(100)    default ''                 comment '抖音号',
  douyin_qr         varchar(500)    default ''                 comment '抖音二维码',
  shoot_process     text                                      comment '拍摄流程',
  faq_content       text                                      comment '常见问题',
  status            char(1)         default '0'                comment '状态（0正常 1停用）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default null               comment '备注',
  del_flag          char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  primary key (id),
  unique key uk_photo_brand_config_photographer (photographer_id),
  key idx_photo_brand_config_status (photographer_id, status, del_flag)
) engine=innodb default charset=utf8mb4 collate=utf8mb4_general_ci comment = 'PhotoNest摄影师品牌主页配置表';

-- ----------------------------
-- 3、作品分类表
-- ----------------------------
drop table if exists photo_work_category;
create table photo_work_category (
  id              bigint(20)      not null auto_increment    comment '作品分类ID',
  photographer_id bigint(20)      not null                   comment '摄影师ID',
  category_name   varchar(50)     not null                   comment '分类名称',
  category_icon   varchar(500)    default ''                 comment '分类图标',
  sort            int(11)         default 0                  comment '显示顺序',
  status          char(1)         default '0'                comment '状态（0正常 1停用）',
  create_by       varchar(64)     default ''                 comment '创建者',
  create_time     datetime                                   comment '创建时间',
  update_by       varchar(64)     default ''                 comment '更新者',
  update_time     datetime                                   comment '更新时间',
  remark          varchar(500)    default null               comment '备注',
  del_flag        char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  primary key (id),
  unique key uk_photo_work_category_name (photographer_id, category_name, del_flag),
  key idx_photo_work_category_list (photographer_id, status, del_flag, sort)
) engine=innodb default charset=utf8mb4 collate=utf8mb4_general_ci comment = 'PhotoNest作品分类表';

-- ----------------------------
-- 4、作品组表
-- ----------------------------
drop table if exists photo_work;
create table photo_work (
  id                bigint(20)      not null auto_increment    comment '作品ID',
  photographer_id   bigint(20)      not null                   comment '摄影师ID',
  category_id       bigint(20)      default null               comment '作品分类ID',
  title             varchar(100)    not null                   comment '作品标题',
  cover_url         varchar(500)    default ''                 comment '作品封面图',
  tags              varchar(255)    default ''                 comment '作品标签，多个用逗号分隔',
  shoot_type        varchar(50)     default ''                 comment '拍摄类型',
  shoot_location    varchar(100)    default ''                 comment '拍摄地点',
  shoot_time        datetime                                   comment '拍摄时间',
  description       text                                      comment '作品说明',
  is_home_recommend char(1)         default '0'                comment '是否首页推荐（0否 1是）',
  publish_time      datetime                                   comment '发布时间',
  sort              int(11)         default 0                  comment '显示顺序',
  view_count        bigint(20)      default 0                  comment '浏览次数',
  status            char(1)         default '0'                comment '状态（0已发布 1下架 2草稿）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default null               comment '备注',
  del_flag          char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  primary key (id),
  key idx_photo_work_photographer (photographer_id),
  key idx_photo_work_category (photographer_id, category_id, status, del_flag),
  key idx_photo_work_home (photographer_id, is_home_recommend, status, del_flag, sort, publish_time),
  key idx_photo_work_publish (photographer_id, status, del_flag, publish_time)
) engine=innodb default charset=utf8mb4 collate=utf8mb4_general_ci comment = 'PhotoNest作品组表';

-- ----------------------------
-- 5、作品图片表
-- ----------------------------
drop table if exists photo_work_image;
create table photo_work_image (
  id              bigint(20)      not null auto_increment    comment '作品图片ID',
  photographer_id bigint(20)      not null                   comment '摄影师ID',
  work_id         bigint(20)      not null                   comment '作品ID',
  original_url    varchar(500)    default ''                 comment '原图地址',
  display_url     varchar(500)    default ''                 comment '展示图地址',
  thumbnail_url   varchar(500)    default ''                 comment '缩略图地址',
  watermark_url   varchar(500)    default ''                 comment '水印图地址',
  file_name       varchar(255)    default ''                 comment '文件名称',
  file_size       bigint(20)      default 0                  comment '文件大小，单位字节',
  width           int(11)         default null               comment '图片宽度',
  height          int(11)         default null               comment '图片高度',
  sort            int(11)         default 0                  comment '显示顺序',
  status          char(1)         default '0'                comment '状态（0正常 1隐藏）',
  create_by       varchar(64)     default ''                 comment '创建者',
  create_time     datetime                                   comment '创建时间',
  update_by       varchar(64)     default ''                 comment '更新者',
  update_time     datetime                                   comment '更新时间',
  remark          varchar(500)    default null               comment '备注',
  del_flag        char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  primary key (id),
  key idx_photo_work_image_photographer (photographer_id),
  key idx_photo_work_image_work (photographer_id, work_id, status, del_flag, sort)
) engine=innodb default charset=utf8mb4 collate=utf8mb4_general_ci comment = 'PhotoNest作品图片表';

-- ----------------------------
-- 6、拍摄套系表
-- ----------------------------
drop table if exists photo_package;
create table photo_package (
  id                   bigint(20)      not null auto_increment    comment '套系ID',
  photographer_id      bigint(20)      not null                   comment '摄影师ID',
  package_name         varchar(100)    not null                   comment '套系名称',
  cover_url            varchar(500)    default ''                 comment '套系封面图',
  price_display_type   varchar(20)     default 'public'           comment '价格展示方式（public公开价格 negotiable价格面议 from起拍价 hidden隐藏价格）',
  price_text           varchar(100)    default ''                 comment '价格展示文案',
  price                decimal(10,2)   default null               comment '套系价格',
  deposit_amount       decimal(10,2)   default null               comment '定金金额',
  duration_minutes     int(11)         default null               comment '拍摄时长，单位分钟',
  original_photo_count int(11)         default null               comment '底片数量',
  retouch_photo_count  int(11)         default null               comment '精修数量',
  suitable_people      varchar(500)    default ''                 comment '适合人群',
  service_content      text                                      comment '服务内容',
  delivery_cycle       varchar(100)    default ''                 comment '交付周期',
  extra_photo_price    decimal(10,2)   default null               comment '加片价格',
  extra_hour_price     decimal(10,2)   default null               comment '加时价格',
  notice               text                                      comment '拍摄须知',
  reschedule_rule      text                                      comment '改期规则',
  sort                 int(11)         default 0                  comment '显示顺序',
  status               char(1)         default '0'                comment '状态（0上架 1下架 2草稿）',
  create_by            varchar(64)     default ''                 comment '创建者',
  create_time          datetime                                   comment '创建时间',
  update_by            varchar(64)     default ''                 comment '更新者',
  update_time          datetime                                   comment '更新时间',
  remark               varchar(500)    default null               comment '备注',
  del_flag             char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  primary key (id),
  key idx_photo_package_photographer (photographer_id),
  key idx_photo_package_list (photographer_id, status, del_flag, sort),
  key idx_photo_package_price_type (photographer_id, price_display_type)
) engine=innodb default charset=utf8mb4 collate=utf8mb4_general_ci comment = 'PhotoNest拍摄套系表';

-- ----------------------------
-- 7、套系明细表
-- ----------------------------
drop table if exists photo_package_item;
create table photo_package_item (
  id              bigint(20)      not null auto_increment    comment '套系明细ID',
  photographer_id bigint(20)      not null                   comment '摄影师ID',
  package_id      bigint(20)      not null                   comment '套系ID',
  item_name       varchar(100)    not null                   comment '明细名称',
  item_value      varchar(500)    default ''                 comment '明细内容',
  sort            int(11)         default 0                  comment '显示顺序',
  create_by       varchar(64)     default ''                 comment '创建者',
  create_time     datetime                                   comment '创建时间',
  update_by       varchar(64)     default ''                 comment '更新者',
  update_time     datetime                                   comment '更新时间',
  remark          varchar(500)    default null               comment '备注',
  del_flag        char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  primary key (id),
  key idx_photo_package_item_photographer (photographer_id),
  key idx_photo_package_item_package (photographer_id, package_id, del_flag, sort)
) engine=innodb default charset=utf8mb4 collate=utf8mb4_general_ci comment = 'PhotoNest套系明细表';

-- ----------------------------
-- 8、摄影师客户表
-- ----------------------------
drop table if exists photo_customer;
create table photo_customer (
  id              bigint(20)      not null auto_increment    comment '客户ID',
  photographer_id bigint(20)      not null                   comment '摄影师ID',
  openid          varchar(100)    default null               comment '微信小程序openid',
  nickname        varchar(100)    default ''                 comment '微信昵称',
  avatar_url      varchar(500)    default ''                 comment '微信头像',
  real_name       varchar(50)     default ''                 comment '真实姓名',
  phone           varchar(20)     default ''                 comment '手机号',
  wechat_id       varchar(100)    default ''                 comment '微信号',
  status          char(1)         default '0'                comment '状态（0正常 1禁用）',
  create_by       varchar(64)     default ''                 comment '创建者',
  create_time     datetime                                   comment '创建时间',
  update_by       varchar(64)     default ''                 comment '更新者',
  update_time     datetime                                   comment '更新时间',
  remark          varchar(500)    default null               comment '备注',
  del_flag        char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  primary key (id),
  -- 注意：openid 允许为空，MySQL 唯一索引允许多条 NULL。
  -- 因此 openid 为空时不能仅依赖 uk_photo_customer_openid 判断客户唯一性。
  -- 第一版可通过手机号、微信号、预约记录辅助识别客户。
  unique key uk_photo_customer_openid (photographer_id, openid),
  key idx_photo_customer_photographer (photographer_id),
  key idx_photo_customer_phone (photographer_id, phone),
  key idx_photo_customer_wechat_phone (photographer_id, wechat_id, phone),
  key idx_photo_customer_status (photographer_id, status, del_flag)
) engine=innodb default charset=utf8mb4 collate=utf8mb4_general_ci comment = 'PhotoNest摄影师客户表';

-- ----------------------------
-- 9、预约咨询表
-- ----------------------------
drop table if exists photo_booking;
create table photo_booking (
  id                bigint(20)      not null auto_increment    comment '预约咨询ID',
  photographer_id   bigint(20)      not null                   comment '摄影师ID',
  customer_id       bigint(20)      default null               comment '客户ID',
  booking_no        varchar(64)     not null                   comment '预约咨询编号',
  customer_name     varchar(50)     default ''                 comment '客户姓名',
  phone             varchar(20)     default ''                 comment '手机号',
  wechat_id         varchar(100)    default ''                 comment '微信号',
  shoot_type        varchar(50)     default ''                 comment '拍摄类型',
  package_id        bigint(20)      default null               comment '意向套系ID',
  expected_date     date                                       comment '意向日期',
  expected_time     varchar(100)    default ''                 comment '意向时间段',
  expected_location varchar(100)    default ''                 comment '意向地点',
  people_count      int(11)         default null               comment '拍摄人数',
  has_child         char(1)         default '0'                comment '是否有小孩（0否 1是）',
  requirement       text                                      comment '拍摄需求',
  source_channel    varchar(50)     default 'unknown'          comment '来源渠道（xiaohongshu douyin wechat friend_circle manual_share unknown）',
  source_page       varchar(100)    default ''                 comment '来源页面',
  source_type       varchar(20)     default 'page'             comment '来源类型（page页面 work作品 package套系）',
  source_work_id    bigint(20)      default null               comment '来源作品ID',
  source_package_id bigint(20)      default null               comment '来源套系ID',
  status            char(1)         default '0'                comment '状态（0待处理 1已联系 2已预约 3已取消 4无效线索）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default null               comment '备注',
  del_flag          char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  primary key (id),
  unique key uk_photo_booking_no (booking_no),
  key idx_photo_booking_photographer (photographer_id),
  key idx_photo_booking_customer (photographer_id, customer_id),
  key idx_photo_booking_status (photographer_id, status, del_flag, create_time),
  key idx_photo_booking_source_work (photographer_id, source_type, source_work_id),
  key idx_photo_booking_source_package (photographer_id, source_type, source_package_id),
  key idx_photo_booking_channel (photographer_id, source_channel, create_time)
) engine=innodb default charset=utf8mb4 collate=utf8mb4_general_ci comment = 'PhotoNest预约咨询表';
