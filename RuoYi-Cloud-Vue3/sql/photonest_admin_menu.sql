-- PhotoNest 超级管理员端菜单
-- 仅生成菜单 SQL，不自动执行。

SET NAMES utf8mb4;

delete from sys_menu where menu_id between 2000 and 2081;

insert into sys_menu values('2000', 'PhotoNest', '0', '4', 'photo', null, '', '', 1, 0, 'M', '0', '0', '', 'camera', 'admin', sysdate(), '', null, 'PhotoNest摄影业务目录');

insert into sys_menu values('2001', '摄影师管理', '2000', '1', 'photographer', 'photo/photographer/index', '', '', 1, 0, 'C', '0', '0', 'photo:photographer:list', 'peoples', 'admin', sysdate(), '', null, 'PhotoNest摄影师管理');
insert into sys_menu values('2002', '品牌主页配置', '2000', '2', 'brand', 'photo/brand/index', '', '', 1, 0, 'C', '0', '0', 'photo:brand:view', 'edit', 'admin', sysdate(), '', null, 'PhotoNest品牌主页配置');
insert into sys_menu values('2003', '作品分类管理', '2000', '3', 'category', 'photo/category/index', '', '', 1, 0, 'C', '0', '0', 'photo:category:list', 'tree', 'admin', sysdate(), '', null, 'PhotoNest作品分类管理');
insert into sys_menu values('2004', '作品管理', '2000', '4', 'work', 'photo/work/index', '', '', 1, 0, 'C', '0', '0', 'photo:work:list', 'picture', 'admin', sysdate(), '', null, 'PhotoNest作品管理');
insert into sys_menu values('2005', '作品图片管理', '2000', '5', 'workImage', 'photo/workImage/index', '', '', 1, 0, 'C', '0', '0', 'photo:workImage:list', 'image', 'admin', sysdate(), '', null, 'PhotoNest作品图片管理');
insert into sys_menu values('2006', '套系管理', '2000', '6', 'package', 'photo/package/index', '', '', 1, 0, 'C', '0', '0', 'photo:package:list', 'money', 'admin', sysdate(), '', null, 'PhotoNest套系管理');
insert into sys_menu values('2007', '套系明细管理', '2000', '7', 'packageItem', 'photo/packageItem/index', '', '', 1, 0, 'C', '0', '0', 'photo:packageItem:list', 'list', 'admin', sysdate(), '', null, 'PhotoNest套系明细管理');
insert into sys_menu values('2008', '预约咨询管理', '2000', '8', 'booking', 'photo/booking/index', '', '', 1, 0, 'C', '0', '0', 'photo:booking:list', 'message', 'admin', sysdate(), '', null, 'PhotoNest预约咨询管理');

insert into sys_menu values('2010', '摄影师查询', '2001', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'photo:photographer:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2011', '摄影师新增', '2001', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'photo:photographer:add', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2012', '摄影师修改', '2001', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'photo:photographer:edit', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2013', '摄影师删除', '2001', '4', '#', '', '', '', 1, 0, 'F', '0', '0', 'photo:photographer:remove', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2014', '摄影师状态', '2001', '5', '#', '', '', '', 1, 0, 'F', '0', '0', 'photo:photographer:status', '#', 'admin', sysdate(), '', null, '');

insert into sys_menu values('2020', '品牌查看', '2002', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'photo:brand:view', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2021', '品牌编辑', '2002', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'photo:brand:edit', '#', 'admin', sysdate(), '', null, '');

insert into sys_menu values('2030', '分类查询', '2003', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'photo:category:list', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2031', '分类新增', '2003', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'photo:category:add', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2032', '分类修改', '2003', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'photo:category:edit', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2033', '分类删除', '2003', '4', '#', '', '', '', 1, 0, 'F', '0', '0', 'photo:category:remove', '#', 'admin', sysdate(), '', null, '');

insert into sys_menu values('2040', '作品查询', '2004', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'photo:work:list', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2041', '作品新增', '2004', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'photo:work:add', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2042', '作品修改', '2004', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'photo:work:edit', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2043', '作品删除', '2004', '4', '#', '', '', '', 1, 0, 'F', '0', '0', 'photo:work:remove', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2044', '作品状态', '2004', '5', '#', '', '', '', 1, 0, 'F', '0', '0', 'photo:work:status', '#', 'admin', sysdate(), '', null, '');

insert into sys_menu values('2050', '作品图片查询', '2005', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'photo:workImage:list', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2051', '作品图片新增', '2005', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'photo:workImage:add', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2052', '作品图片修改', '2005', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'photo:workImage:edit', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2053', '作品图片删除', '2005', '4', '#', '', '', '', 1, 0, 'F', '0', '0', 'photo:workImage:remove', '#', 'admin', sysdate(), '', null, '');

insert into sys_menu values('2060', '套系查询', '2006', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'photo:package:list', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2061', '套系新增', '2006', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'photo:package:add', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2062', '套系修改', '2006', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'photo:package:edit', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2063', '套系删除', '2006', '4', '#', '', '', '', 1, 0, 'F', '0', '0', 'photo:package:remove', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2064', '套系状态', '2006', '5', '#', '', '', '', 1, 0, 'F', '0', '0', 'photo:package:status', '#', 'admin', sysdate(), '', null, '');

insert into sys_menu values('2070', '套系明细查询', '2007', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'photo:packageItem:list', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2071', '套系明细新增', '2007', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'photo:packageItem:add', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2072', '套系明细修改', '2007', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'photo:packageItem:edit', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2073', '套系明细删除', '2007', '4', '#', '', '', '', 1, 0, 'F', '0', '0', 'photo:packageItem:remove', '#', 'admin', sysdate(), '', null, '');

insert into sys_menu values('2080', '预约查询', '2008', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'photo:booking:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2081', '预约状态', '2008', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'photo:booking:status', '#', 'admin', sysdate(), '', null, '');
