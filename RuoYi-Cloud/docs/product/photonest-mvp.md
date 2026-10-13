# PhotoNest 多摄影师微信小程序接单系统 MVP 产品需求文档

## 一、项目背景

我现在要基于若依项目二次开发一个名为 **PhotoNest** 的摄影师微信小程序接单系统。

PhotoNest 不是单一摄影师自用工具，而是一个支持 **多个摄影师入驻使用** 的系统。

系统关系如下：

```text
平台方 / 系统管理员
    ↓
摄影师用户
    ↓
摄影师自己的客户
```

也就是说，**摄影师是 PhotoNest 的客户，摄影师的客人才是小程序里的最终用户**。

项目目标是帮助摄影师搭建自己的微信小程序主页，让摄影师可以展示作品、展示套系、接收预约咨询，并且后续可以继续扩展在线选片、精修交付、订单管理等功能。

第一阶段暂时只做：

```text
摄影师主页展示
作品展示
套系展示
预约咨询
摄影师移动工作台
平台方管理摄影师
```

第一阶段暂时不做：

```text
优惠券
积分
会员等级
分销
拼团
复杂营销活动
微信支付
在线选片
精修交付
团队协作
平台摄影师广场
```

------

## 二、项目命名规范

项目英文名：

```text
PhotoNest
```

推荐中文名：

```text
影巢
```

命名建议：

```text
项目名：PhotoNest
产品文档：docs/product/photonest-mvp.md
SQL 文件：sql/photonest_mvp.sql
后端业务模块：ruoyi-photo
后端包名：com.ruoyi.photo
数据库表前缀：photo_
小程序目录：photonest-miniapp
后台显示名称：PhotoNest 摄影管理
```

虽然项目名叫 PhotoNest，但数据库表名前缀建议统一使用：

```text
photo_
```

例如：

```text
photo_photographer
photo_brand_config
photo_work_category
photo_work
photo_work_image
photo_package
photo_package_item
photo_customer
photo_booking
```

------

## 三、系统端划分

PhotoNest 应该分成三个端：

```text
1. 平台管理端：平台方使用
2. 摄影师工作台：摄影师使用
3. 客户小程序端：摄影师的客户使用
```

------

## 四、平台管理端

平台管理端由系统管理员使用，可以直接基于若依后台管理系统开发。

平台方可以管理所有摄影师和所有平台数据。

平台管理端功能包括：

```text
摄影师账号管理
摄影师主页管理
摄影师作品管理
摄影师套系管理
摄影师预约咨询查看
摄影师账号启用 / 禁用
摄影师内容下架
摄影师存储用量查看
平台配置管理
```

第一阶段平台方至少需要支持：

```text
创建摄影师账号
编辑摄影师基础信息
启用 / 禁用摄影师账号
查看某个摄影师的主页配置
查看某个摄影师的作品、套系和预约咨询
```

------

## 五、摄影师工作台

摄影师工作台是给摄影师自己使用的管理端。

它本质上类似后台管理系统，但不能直接把传统若依后台暴露给摄影师使用。因为普通摄影师不是程序员，如果直接使用若依后台，会觉得复杂。

摄影师工作台应该更像一个手机端 App / 微信小程序工作台，操作简单、视觉高级、卡片式、大按钮、少字段、流程化。

摄影师工作台可以和客户小程序端共用一个微信小程序，但入口和权限必须分开。

摄影师工作台功能包括：

```text
编辑主页信息
上传作品
管理作品分类
上传套系
管理套系
查看预约咨询
处理预约咨询
查看客户信息
查看主页访问情况
查看作品数量
查看套系数量
```

第一阶段摄影师工作台至少需要支持：

```text
摄影师登录
编辑自己的品牌主页
上传 / 编辑 / 删除作品
上传作品封面
上传作品图片
设置作品是否首页推荐
配置 / 编辑 / 下架套系
查看客户预约咨询
修改预约咨询状态
```

摄影师工作台底部 Tab 建议：

```text
首页
作品
预约
套系
我的
```

摄影师工作台首页展示：

```text
待处理预约数量
作品数量
套系数量
主页访问量，可后续做
快捷发布作品
快捷发布套系
快捷编辑主页
```

------

## 六、客户小程序端

客户小程序端是给摄影师的客户看的页面。

客户不是进入 PhotoNest 平台主页，而是进入某个摄影师自己的主页。

客户来源主要是：

```text
小红书
抖音
朋友圈
微信聊天
摄影师分享的小程序码
```

客户打开小程序后看到的是：

```text
某个摄影师的首页
某个摄影师的作品
某个摄影师的套系
某个摄影师的关于
某个摄影师的预约咨询入口
```

客户小程序端底部 Tab 建议：

```text
首页
作品
套系
关于
我的
```

------

## 七、多摄影师 / 多租户核心规则

因为 PhotoNest 是给多个摄影师使用的系统，所以必须从第一版开始支持多摄影师数据隔离。

核心规则：

```text
所有摄影师业务数据必须绑定 photographer_id。
摄影师只能查看和管理自己的数据。
客户打开小程序时，必须识别当前访问的是哪个摄影师。
客户看到的作品、套系、关于信息、预约入口，全部属于当前摄影师。
```

需要新增摄影师表：

```text
photo_photographer
```

核心字段建议：

```text
id
user_id
brand_name
photographer_name
share_code
avatar
cover_image
city
phone
wechat_id
wechat_qr
xiaohongshu_id
xiaohongshu_qr
douyin_id
douyin_qr
status
plan_type
expire_time
storage_limit
work_limit
package_limit
create_by
create_time
update_by
update_time
remark
del_flag
```

其中：

```text
share_code
```

用于客户打开小程序时识别摄影师。

例如客户入口：

```text
pages/index/index?shareCode=pn_a8k39d
```

系统通过 shareCode 查询摄影师信息，然后展示该摄影师的主页、作品、套系和关于信息。

不要直接暴露数据库 ID，建议使用 shareCode。

------

## 八、客户归属设计

第一阶段建议客户按摄影师隔离。

也就是说，同一个微信用户如果分别访问摄影师 A 和摄影师 B，可以在系统里形成两条客户记录。

客户表建议增加：

```text
photographer_id
```

第一版采用：

```text
一个客户属于某个摄影师
同一个 openid 可以在不同 photographer_id 下生成不同客户记录
客户是摄影师的客户资产，不是平台统一客户资产
```

客户表建议：

```text
photo_customer
```

核心字段：

```text
id
photographer_id
openid
nickname
avatar_url
phone
wechat_id
real_name
status
create_time
update_time
remark
del_flag
```

------

## 九、客户初步了解摄影师阶段业务逻辑

客户完整路径：

```text
小红书 / 抖音 / 朋友圈看到摄影师内容
        ↓
添加摄影师微信
        ↓
摄影师发送微信小程序
        ↓
客户打开小程序，系统根据 shareCode 识别摄影师
        ↓
进入该摄影师首页
        ↓
查看品牌信息 / 摄影师介绍
        ↓
查看首页推荐作品
        ↓
点击作品封面进入作品详情
        ↓
返回首页时保留原来的浏览位置
        ↓
继续下滑查看更多内容
        ↓
点击 More 进入作品 Tab
        ↓
查看更多完整作品案例
        ↓
进入套系 Tab 查看价格和套餐
        ↓
通过右下角浮动按钮预约咨询
        ↓
摄影师在工作台收到预约咨询
```

客户在这个阶段主要判断：

```text
这个摄影师是谁？
这个摄影师的审美怎么样？
这个摄影师拍过哪些真实客片？
这个摄影师是否适合我？
价格和套餐我能不能接受？
如果我感兴趣，应该从哪里预约咨询？
```

------

## 十、客户首页业务逻辑

客户打开小程序后默认进入首页。

首页展示当前摄影师的信息。

首页主要包括：

```text
顶部品牌区域
关于我模块
首页作品展示模块
联系方式模块
右下角浮动预约咨询按钮
```

### 1. 顶部品牌区域

展示内容：

```text
摄影师 Logo
品牌名称
摄影师名称
英文副标题
首页主视觉图片
所在城市
```

这些信息来自当前 shareCode 对应的 photographer_id。

------

### 2. 关于我模块

首页中展示简短的摄影师介绍。

建议标题：

```text
关于我
```

展示内容：

```text
英文标题：About Me
中文标题：关于我
摄影师介绍图 / Logo 装饰图
摄影师简介
预约咨询按钮
收藏 / 关注按钮，可选
```

如果第一版不想做复杂收藏关系，可以先不做关注功能，或者改成“加微信”。

------

### 3. 首页作品展示模块

首页作品展示不是完整作品库，而是精选作品展示区。

展示规则：

```text
首页作品展示区最多展示 8 组作品。
优先展示后台设置为“首页推荐”的作品。
如果首页推荐作品不足 8 个，则按照发布时间倒序补齐。
如果作品数量不足 8 组，则展示实际数量。
如果作品数量为单数，右侧显示占位卡片。
占位卡片建议展示“查看更多作品 →”，点击后跳转到作品 Tab。
点击作品封面进入作品详情页。
从作品详情页返回首页时，需要恢复首页原来的滚动位置。
```

每个作品卡片展示：

```text
作品封面
作品标题
作品标签
收藏图标，可选
```

每个作品卡片代表一组作品，而不是一张照片。

------

### 4. More 按钮

首页作品展示区底部显示 More 按钮。

点击 More 后，跳转到底部 Tab 的作品页面。

------

## 十一、作品 Tab 业务逻辑

作品 Tab 是当前摄影师的完整作品库。

作品必须以“作品组”为单位展示，而不是以单张照片为单位展示。

一组作品对应一次真实拍摄，例如：

```text
一对客人的领证拍摄
一场婚礼跟拍
一次单人写真
一次儿童生日照
一次情侣写真
```

作品分类示例：

```text
全部
领证
单人写真
情侣写真
婚礼
儿童
生日
活动
其他
```

作品列表规则：

```text
默认展示当前摄影师的全部已发布作品。
按照发布时间倒序排列。
支持分页加载。
每页展示 10 或 20 组作品。
支持分类筛选。
点击作品封面进入作品详情页。
从作品详情页返回作品 Tab 时，需要恢复作品列表原来的滚动位置。
```

------

## 十二、作品详情页业务逻辑

客户点击首页或作品 Tab 中的作品封面后，进入作品详情页。

作品详情页展示：

```text
作品标题
作品标签
拍摄类型
拍摄地点
拍摄时间
作品说明
作品图片列表
```

图片展示规则：

```text
按照后台设置的排序展示。
支持图片预览。
可展示水印图。
第一版不直接暴露高清原图。
```

作品详情页底部提供转化按钮：

```text
咨询同款拍摄
预约咨询
```

如果客户从作品详情页点击预约，需要记录：

```text
source_type = work
source_work_id = 当前作品 ID
```

返回逻辑：

```text
如果从首页进入，返回首页，并恢复首页原来的 scrollTop。
如果从作品 Tab 进入，返回作品 Tab，并恢复作品列表原来的 scrollTop。
```

------

## 十三、套系 Tab 业务逻辑

套系 Tab 用于展示当前摄影师可预约的拍摄套餐。

客户在看完作品后，通常会进入套系页判断：

```text
价格是多少？
拍多久？
给多少底片？
给多少精修？
适不适合我的需求？
```

### 1. 套系列表展示内容

每个套餐卡片展示：

```text
套餐封面
套餐名称
套餐价格
拍摄时长
底片数量
精修数量
简短说明
预约按钮
```

### 2. 套系详情页展示内容

客户点击套餐后，进入套系详情页。

展示内容：

```text
套餐名称
套餐封面
套餐价格
定金金额
拍摄时长
适合人群
服务内容
底片数量
精修数量
交付周期
加片价格
加时价格
拍摄须知
改期规则
预约按钮
```

### 3. 套系价格展示方式

不同摄影师对价格公开程度不同，所以套餐价格不要只设计一个 price 字段。

建议支持：

```text
公开价格
价格面议
仅显示起拍价
隐藏价格，点击咨询
```

套餐表建议增加：

```text
price_display_type
price_text
price
deposit_amount
```

示例：

```text
领证跟拍 ¥699
婚礼跟拍 价格面议
商业拍摄 请咨询
写真套餐 ¥599 起
```

### 4. 套系与作品关联

套系详情页可以展示相关作品：

```text
这个套系的真实案例
```

作品详情页也可以展示相关套系：

```text
这组作品适合的套餐
```

第一版可以先预留关联字段，不一定立即实现复杂展示。

如果客户从套系详情页点击预约，需要记录：

```text
source_type = package
source_package_id = 当前套餐 ID
```

------

## 十四、关于 Tab 业务逻辑

关于 Tab 是首页“关于我”的完整版本。

展示内容：

```text
摄影师介绍
品牌故事
拍摄理念
服务城市
联系方式
微信二维码
小红书主页
抖音主页
拍摄流程
常见问题
```

第一版至少展示：

```text
摄影师介绍
微信号
手机号
所在城市
微信二维码
小红书号
小红书二维码
抖音号
抖音二维码
```

注意：微信小程序中不要把“点击直接跳转小红书 / 抖音 App”作为第一版强依赖功能。

第一版更稳妥的做法：

```text
展示小红书号 + 复制按钮 + 小红书主页二维码
展示抖音号 + 复制按钮 + 抖音主页二维码
展示微信号 + 复制按钮 + 微信二维码
```

------

## 十五、全局预约按钮业务逻辑

在以下客户页面右下角显示浮动预约按钮：

```text
首页
作品 Tab
套系 Tab
关于 Tab
我的 Tab
作品详情页
套系详情页
```

按钮文案：

```text
预约咨询
```

不要直接叫“立即预约”，因为初次了解阶段，客户很多时候还没有决定下单，只是想先咨询。

点击预约按钮后进入预约咨询页面。

需要携带来源信息：

```text
当前摄影师 photographer_id
当前页面路径 source_page
来源渠道 source_channel
来源类型 source_type
来源作品 ID source_work_id
来源套餐 ID source_package_id
```

示例：

```text
客户从首页右下角点击预约：
source_type = page
source_page = home

客户从作品详情页点击预约：
source_type = work
source_work_id = 1001

客户从套系详情页点击预约：
source_type = package
source_package_id = 2001
```

------

## 十六、预约咨询页面

预约咨询页面第一版为轻量表单。

客户填写：

```text
姓名
微信号
手机号
拍摄类型
意向套餐
意向日期
意向地点
拍摄人数
是否有小孩
拍摄需求
备注
```

如果客户从作品详情进入，自动带入：

```text
喜欢的作品
```

如果客户从套系详情进入，自动带入：

```text
意向套餐
```

提交后逻辑：

```text
系统生成一条预约咨询记录。
预约记录绑定 photographer_id。
摄影师工作台显示待处理预约。
客户看到提交成功页面。
提交成功页面展示摄影师微信二维码或复制微信号。
```

预约状态建议：

```text
待处理
已联系
已预约
已取消
无效线索
```

------

## 十七、预约不等于订单

第一阶段要明确：

```text
预约咨询 ≠ 正式订单
```

客户提交预约咨询只是线索，不是订单。

后续可以扩展：

```text
预约咨询
    ↓
摄影师确认
    ↓
生成正式订单
    ↓
锁定档期
    ↓
上传底片
    ↓
客户选片
    ↓
上传精修
    ↓
交付完成
```

但第一版只做到预约咨询和摄影师处理线索。

------

## 十八、预约来源追踪

预约表需要记录客户来源。

建议字段：

```text
source_channel
source_page
source_type
source_work_id
source_package_id
```

source_channel 示例：

```text
xiaohongshu
douyin
wechat
friend_circle
manual_share
unknown
```

这样摄影师后续可以知道：

```text
客户主要来自哪里？
哪组作品最能带来咨询？
哪个套餐咨询最多？
```

这个比优惠券、积分更重要。

------

## 十九、图片存储与成本控制

摄影师系统中最大成本可能不是接口，而是图片存储和流量。

第一版必须考虑：

```text
图片压缩
缩略图
水印图
原图存储
存储空间限制
每个摄影师上传容量
```

建议第一版规则：

```text
作品展示图自动压缩。
生成缩略图。
不上传 RAW。
不上传超大原图。
每张图片限制大小。
每个摄影师限制总存储空间。
```

建议限制：

```text
单张图片最大 5MB。
展示图最长边压缩到 2000px。
缩略图最长边 600px。
每个摄影师默认 2GB 空间。
```

作品图片表建议区分：

```text
original_url
display_url
thumbnail_url
watermark_url
```

第一版客户侧展示 display_url 或 watermark_url，不直接暴露 original_url。

------

## 二十、内容审核与风控

因为多个摄影师都可以上传内容，所以平台方需要有基础风控能力。

第一版可以不做 AI 审核，但必须支持：

```text
禁用摄影师账号
下架某个摄影师主页
下架某组作品
隐藏某个套餐
删除违规图片
```

每个内容表建议有：

```text
status
del_flag
```

------

## 二十一、商业模式预留

第一版不一定要做收费，但数据库可以预留商业化字段。

摄影师表建议预留：

```text
plan_type
expire_time
storage_limit
work_limit
package_limit
```

后续可扩展：

```text
免费版
专业版
到期停用
作品数量限制
套系数量限制
存储容量限制
是否允许自定义主页
是否允许去平台标识
```

------

## 二十二、第一阶段建议数据表

第一阶段建议至少包含：

```text
photo_photographer              摄影师账号 / 主页主体
photo_brand_config              摄影师品牌主页配置
photo_work_category             作品分类
photo_work                      作品组
photo_work_image                作品图片
photo_package                   套餐
photo_package_item              套餐明细
photo_customer                  客户
photo_booking                   预约咨询
```

所有业务表必须包含：

```text
photographer_id
```

除了平台级配置表或确实不归属摄影师的数据。

所有表尽量遵守若依字段风格：

```text
create_by
create_time
update_by
update_time
remark
del_flag
```

------

## 二十三、核心表说明

### 1. photo_photographer

用于记录摄影师账号和主页主体。

核心字段：

```text
id
user_id
brand_name
photographer_name
share_code
avatar
cover_image
city
phone
wechat_id
wechat_qr
xiaohongshu_id
xiaohongshu_qr
douyin_id
douyin_qr
status
plan_type
expire_time
storage_limit
work_limit
package_limit
create_by
create_time
update_by
update_time
remark
del_flag
```

------

### 2. photo_brand_config

用于摄影师主页配置。

核心字段：

```text
id
photographer_id
brand_name
photographer_name
logo_url
cover_image
subtitle
intro
about_content
city
phone
wechat_id
wechat_qr
xiaohongshu_id
xiaohongshu_qr
douyin_id
douyin_qr
status
create_by
create_time
update_by
update_time
remark
del_flag
```

------

### 3. photo_work_category

用于作品分类。

核心字段：

```text
id
photographer_id
category_name
category_icon
sort
status
create_by
create_time
update_by
update_time
remark
del_flag
```

------

### 4. photo_work

用于作品组。

一组作品对应一次真实拍摄。

核心字段：

```text
id
photographer_id
category_id
title
cover_url
tags
shoot_type
shoot_location
shoot_time
description
is_home_recommend
publish_time
sort
status
create_by
create_time
update_by
update_time
remark
del_flag
```

------

### 5. photo_work_image

用于作品组下的多张图片。

核心字段：

```text
id
photographer_id
work_id
original_url
display_url
thumbnail_url
watermark_url
file_name
file_size
width
height
sort
status
create_by
create_time
update_by
update_time
remark
del_flag
```

------

### 6. photo_package

用于摄影师拍摄套餐。

核心字段：

```text
id
photographer_id
package_name
cover_url
price_display_type
price_text
price
deposit_amount
duration_minutes
original_photo_count
retouch_photo_count
suitable_people
service_content
delivery_cycle
extra_photo_price
extra_hour_price
notice
reschedule_rule
sort
status
create_by
create_time
update_by
update_time
remark
del_flag
```

------

### 7. photo_package_item

用于套餐明细。

核心字段：

```text
id
photographer_id
package_id
item_name
item_value
sort
create_by
create_time
update_by
update_time
remark
del_flag
```

------

### 8. photo_customer

用于摄影师客户。

核心字段：

```text
id
photographer_id
openid
nickname
avatar_url
real_name
phone
wechat_id
status
create_time
update_time
remark
del_flag
```

------

### 9. photo_booking

用于预约咨询。

核心字段：

```text
id
photographer_id
customer_id
booking_no
customer_name
phone
wechat_id
shoot_type
package_id
expected_date
expected_location
people_count
has_child
requirement
source_channel
source_page
source_type
source_work_id
source_package_id
status
create_time
update_time
remark
del_flag
```

------

## 二十四、第一阶段 MVP 功能范围

第一阶段只做：

```text
1. 平台方可以创建摄影师账号。
2. 每个摄影师有独立主页 shareCode。
3. 摄影师可以登录工作台。
4. 摄影师可以配置自己的主页信息。
5. 摄影师可以上传作品。
6. 摄影师可以配置作品分类。
7. 摄影师可以设置作品是否首页推荐。
8. 摄影师可以配置套系。
9. 客户通过摄影师分享的小程序码进入该摄影师主页。
10. 客户可以查看该摄影师首页、作品、套系、关于。
11. 客户可以提交预约咨询。
12. 摄影师可以在工作台看到自己的预约咨询。
13. 平台方可以禁用摄影师、下架作品、隐藏套系。
```

第一阶段暂时不做：

```text
微信支付
优惠券
积分
分销
在线选片
精修交付
复杂订单
自动排期
团队协作
平台公开摄影师列表
客户多摄影师比价
```

------

## 二十五、技术要求

请基于当前若依项目结构开发。

要求 Codex 先判断当前项目是：

```text
若依前后端分离版
```

还是：

```text
若依 Cloud 版
```

然后根据项目结构决定模块放置位置。

通用技术要求：

```text
1. 基于若依现有项目结构开发。
2. 新增摄影业务模块，优先命名为 ruoyi-photo。
3. 后端包名使用 com.ruoyi.photo。
4. 表名统一以 photo_ 开头。
5. 后台管理端接口路径使用 /photo/admin/xxx。
6. 摄影师工作台接口路径使用 /photo/photographer/xxx。
7. 客户小程序端接口路径使用 /photo/app/xxx。
8. 管理端接口需要接入若依权限控制。
9. 摄影师工作台接口必须自动根据当前登录摄影师过滤 photographer_id。
10. 客户端接口必须根据 shareCode 或 photographer_id 查询对应摄影师数据。
11. 第一版小程序端登录可以先简化，后续再接微信登录。
12. 文件上传优先复用若依现有上传能力。
13. 图片字段需要区分封面图、缩略图、展示图、水印图、原图。
14. 所有表需要符合若依常用字段规范。
15. 多摄影师数据必须严格隔离。
```

------

## 二十六、给 Codex 的第一条执行指令

请先阅读当前项目结构和 docs/product/photonest-mvp.md。

我现在要基于若依项目开发一个名为 PhotoNest 的多摄影师微信小程序接单系统。

要求：

```text
1. 先判断当前项目是若依前后端分离版还是若依 Cloud 版。
2. 总结当前后端模块结构、前端模块结构、代码生成器结构。
3. 根据 docs/product/photonest-mvp.md，设计 PhotoNest 第一阶段 MVP 的技术实施方案。
4. 暂时不要修改任何代码。
5. 输出你建议新增的模块、数据库表、接口分组、前端页面路径和开发顺序。
6. 特别注意：这是多摄影师系统，不是单摄影师自用系统。所有核心业务数据都必须考虑 photographer_id 数据隔离。
```

------

## 二十七、给 Codex 的第二条执行指令

在你输出技术实施方案并经过我确认后，再开始第一阶段开发。

请先只完成数据库设计，不要生成 Java、Vue、小程序代码。

要求：

```text
1. 根据 docs/product/photonest-mvp.md 设计第一阶段 MVP 的 MySQL 建表 SQL。
2. 表名统一以 photo_ 开头。
3. 所有表遵守若依字段风格，包含 create_by、create_time、update_by、update_time、remark、del_flag。
4. 除平台级表外，所有摄影师业务表必须包含 photographer_id。
5. 需要包含以下表：
   - photo_photographer
   - photo_brand_config
   - photo_work_category
   - photo_work
   - photo_work_image
   - photo_package
   - photo_package_item
   - photo_customer
   - photo_booking
6. photo_photographer 需要包含 share_code，用于客户访问摄影师主页。
7. photo_booking 需要包含 source_channel、source_type、source_page、source_work_id、source_package_id。
8. photo_work 需要包含 is_home_recommend、publish_time、sort、status。
9. photo_package 需要包含 price_display_type、price_text、price、deposit_amount、duration_minutes、original_photo_count、retouch_photo_count。
10. photo_work_image 需要区分 original_url、display_url、thumbnail_url、watermark_url。
11. 请把 SQL 保存到 sql/photonest_mvp.sql。
12. 完成后说明每张表的用途。
13. 暂时不要生成后端代码。
```

------

## 二十八、给 Codex 的第三条执行指令

基于 sql/photonest_mvp.sql，开始生成 PhotoNest 第一阶段后端代码。

要求：

```text
1. 新增摄影业务模块，模块名根据当前若依项目结构决定，优先使用 ruoyi-photo。
2. 包名使用 com.ruoyi.photo。
3. 生成 Domain、Mapper、Mapper XML、Service、ServiceImpl、Controller。
4. 平台管理端接口路径统一为 /photo/admin。
5. 摄影师工作台接口路径统一为 /photo/photographer。
6. 客户小程序端接口路径统一为 /photo/app。
7. 平台管理端接口需要加 @PreAuthorize 权限标识，格式为 photo:模块:操作。
8. 摄影师工作台接口必须根据当前登录摄影师自动过滤 photographer_id。
9. 客户端接口需要根据 shareCode 查询摄影师主页、作品、套系。
10. 先只实现以下功能：
   - 平台方创建 / 编辑 / 禁用摄影师
   - 摄影师主页配置查询和编辑
   - 作品分类 CRUD
   - 作品组 CRUD
   - 作品图片 CRUD
   - 套餐 CRUD
   - 套餐明细 CRUD
   - 客户端根据 shareCode 查询摄影师首页
   - 客户端查询作品列表和作品详情
   - 客户端查询套系列表和套系详情
   - 客户端提交预约咨询
   - 摄影师工作台查看预约咨询列表、详情、修改状态
11. 尽量复用若依已有 BaseController、AjaxResult、TableDataInfo、ExcelUtil 等工具。
12. 修改完成后，告诉我新增和修改了哪些文件。
```

------

## 二十九、给 Codex 的第四条执行指令

请基于当前若依 Vue 后台风格，生成平台管理端页面。

页面包括：

```text
摄影师管理
摄影师主页配置查看
作品分类管理
作品组管理
作品图片管理
套餐管理
预约咨询管理
```

要求：

```text
1. 页面风格保持若依后台一致。
2. 接口路径对接 /photo/admin。
3. 摄影师管理页面支持创建、编辑、启用、禁用。
4. 作品组页面支持按摄影师筛选、设置首页推荐、排序、上下架。
5. 预约咨询页面支持按摄影师筛选、查看来源类型、来源作品、来源套餐。
6. 图片上传复用若依现有上传组件。
7. 完成后告诉我新增和修改了哪些前端文件。
```

------

## 三十、给 Codex 的第五条执行指令

请新增微信小程序端项目 photonest-miniapp。

技术栈使用：

```text
uni-app + Vue3
```

根据 docs/product/photonest-mvp.md 生成 PhotoNest 第一阶段小程序页面。

小程序需要区分：

```text
客户端页面
摄影师工作台页面
```

客户端页面包括：

```text
首页 pages/index/index
作品列表 pages/work/list
作品详情 pages/work/detail
套系列表 pages/package/list
套系详情 pages/package/detail
预约咨询 pages/booking/create
关于 pages/about/index
我的 pages/user/index
```

客户端底部 Tab：

```text
首页
作品
套系
关于
我的
```

摄影师工作台页面包括：

```text
工作台首页 pages/photographer/dashboard
作品管理 pages/photographer/work/list
发布作品 pages/photographer/work/edit
预约管理 pages/photographer/booking/list
套系管理 pages/photographer/package/list
发布套系 pages/photographer/package/edit
我的 pages/photographer/user/index
```

摄影师工作台底部 Tab：

```text
首页
作品
预约
套系
我的
```

客户端要求：

```text
1. 客户打开小程序时，通过 shareCode 识别当前摄影师。
2. 首页展示当前摄影师品牌信息、关于我、最多 8 个首页作品、More 按钮。
3. 首页作品优先展示后台推荐作品，不足 8 个用最新作品补齐，这个逻辑由后端接口返回。
4. 作品列表支持分页加载和分类筛选。
5. 作品详情支持图片列表展示和预约咨询按钮。
6. 套系列表展示套餐卡片。
7. 套系详情展示套餐完整内容和预约按钮。
8. 所有主要页面右下角显示浮动预约咨询按钮。
9. 点击预约时需要携带 source_type、source_page、source_work_id、source_package_id。
10. 从作品详情返回时，尽量保留来源页面的滚动位置。
```

摄影师工作台要求：

```text
1. 摄影师可以查看待处理预约数量。
2. 摄影师可以上传作品。
3. 摄影师可以编辑作品。
4. 摄影师可以设置作品是否首页推荐。
5. 摄影师可以上传 / 编辑套系。
6. 摄影师可以查看预约咨询。
7. 摄影师可以修改预约状态。
8. 摄影师只能看到自己的数据。
```

其他要求：

```text
1. 先使用 mock baseUrl，后续我手动改为真实后端地址。
2. 页面样式使用极简摄影工作室风格。
3. 摄影师工作台要适合手机操作，避免传统后台表格感过重。
```