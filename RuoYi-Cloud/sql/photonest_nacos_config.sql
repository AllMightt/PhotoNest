SET NAMES utf8mb4;

USE `ry-config`;

-- PhotoNest 本地开发网关路由：/photo/** -> ruoyi-photo
UPDATE config_info
SET content = REPLACE(
    content,
    '            # 文件服务\n            - id: ruoyi-file',
    '            # PhotoNest摄影业务\n            - id: ruoyi-photo\n              uri: lb://ruoyi-photo\n              predicates:\n                - Path=/photo/**\n            # 文件服务\n            - id: ruoyi-file'
)
WHERE data_id = 'ruoyi-gateway-dev.yml'
  AND group_id = 'DEFAULT_GROUP'
  AND content NOT LIKE '%id: ruoyi-photo%';

-- 文件静态资源预览路由：后台预览使用 /dev-api/statics/**，经网关转发到 ruoyi-file。
UPDATE config_info
SET content = REPLACE(
    content,
    '            # 文件服务\n            - id: ruoyi-file',
    '            # 文件静态资源\n            - id: ruoyi-file-statics\n              uri: lb://ruoyi-file\n              predicates:\n                - Path=/statics/**\n            # 文件服务\n            - id: ruoyi-file'
)
WHERE data_id = 'ruoyi-gateway-dev.yml'
  AND group_id = 'DEFAULT_GROUP'
  AND content NOT LIKE '%id: ruoyi-file-statics%';

-- PhotoNest 客户端仅登录接口公开；主页、作品、套系、预约等接口登录后访问。
UPDATE config_info
SET content = REPLACE(
    content,
    '      - /csrf\n      - /photo/app/**\n',
    '      - /csrf\n      - /photo/app/auth/wechat-login\n'
)
WHERE data_id = 'ruoyi-gateway-dev.yml'
  AND group_id = 'DEFAULT_GROUP'
  AND content LIKE '%/photo/app/**%';

UPDATE config_info
SET content = REPLACE(
    content,
    '      - /csrf\n',
    '      - /csrf\n      - /photo/app/auth/wechat-login\n'
)
WHERE data_id = 'ruoyi-gateway-dev.yml'
  AND group_id = 'DEFAULT_GROUP'
  AND content NOT LIKE '%/photo/app/auth/wechat-login%';

UPDATE config_info
SET content = REPLACE(
    content,
    '      - /photo/app/auth/wechat-login\n',
    '      - /photo/app/auth/wechat-login\n      - /statics/**\n'
)
WHERE data_id = 'ruoyi-gateway-dev.yml'
  AND group_id = 'DEFAULT_GROUP'
  AND content NOT LIKE '%whites:%/statics/**%';

-- 本地开发文件上传配置：后台 ImageUpload 组件会请求 /file/upload，经网关转发到 ruoyi-file。
-- 若依 Cloud 原始配置使用 Windows 路径 D:/ruoyi/uploadPath，这里改为当前项目内的可写目录。
UPDATE config_info
SET content = REPLACE(
    REPLACE(content, 'path: D:/ruoyi/uploadPath', 'path: /Users/lucky_sun/Desktop/PhotoNest/RuoYi-Cloud/uploadPath'),
    'domain: http://127.0.0.1:9300',
    'domain: http://localhost:9300'
)
WHERE data_id = 'ruoyi-file-dev.yml'
  AND group_id = 'DEFAULT_GROUP';

UPDATE config_info
SET content = REPLACE(
    content,
    'file:\n    domain: http://localhost:9300\n    path:',
    'file:\n    # 存储类型：local 本地存储，minio 文件服务器存储\n    storage: local\n    domain: http://localhost:9300\n    path:'
)
WHERE data_id = 'ruoyi-file-dev.yml'
  AND group_id = 'DEFAULT_GROUP'
  AND content NOT LIKE '%storage:%';

UPDATE config_info
SET content = CONCAT('spring:\n  servlet:\n    multipart:\n      max-file-size: 20MB\n      max-request-size: 20MB\n\n', content)
WHERE data_id = 'ruoyi-file-dev.yml'
  AND group_id = 'DEFAULT_GROUP'
  AND content NOT LIKE '%max-file-size:%';

UPDATE config_info
SET content = REPLACE(
    REPLACE(
        REPLACE(content, 'url: http://127.0.0.1:9000', 'url: http://127.0.0.1:9000'),
        'bucketName: test',
        'bucketName: photonest'
    ),
    'accessKey: minioadmin',
    'accessKey: minioadmin'
)
WHERE data_id = 'ruoyi-file-dev.yml'
  AND group_id = 'DEFAULT_GROUP';

UPDATE config_info
SET content = REPLACE(
    content,
    'bucketName: photonest',
    'bucketName: photonest\n  publicRead: true'
)
WHERE data_id = 'ruoyi-file-dev.yml'
  AND group_id = 'DEFAULT_GROUP'
  AND content LIKE '%bucketName: photonest%'
  AND content NOT LIKE '%publicRead:%';

-- PhotoNest 摄影业务模块配置。
INSERT INTO config_info(data_id, group_id, content, gmt_create, gmt_modified, src_user, src_ip, app_name, tenant_id, c_desc, c_use, effect, type, c_schema, encrypted_data_key)
VALUES (
  'ruoyi-photo-dev.yml',
  'DEFAULT_GROUP',
  '# spring配置\nspring:\n  data:\n    redis:\n      host: localhost\n      port: 6379\n      password: \n  datasource:\n    druid:\n      stat-view-servlet:\n        enabled: true\n        loginUsername: ruoyi\n        loginPassword: 123456\n    dynamic:\n      druid:\n        initial-size: 5\n        min-idle: 5\n        maxActive: 20\n        maxWait: 60000\n        connectTimeout: 30000\n        socketTimeout: 60000\n        timeBetweenEvictionRunsMillis: 60000\n        minEvictableIdleTimeMillis: 300000\n        validationQuery: SELECT 1 FROM DUAL\n        testWhileIdle: true\n        testOnBorrow: false\n        testOnReturn: false\n        poolPreparedStatements: true\n        maxPoolPreparedStatementPerConnectionSize: 20\n        filters: stat,slf4j\n        connectionProperties: druid.stat.mergeSql\\=true;druid.stat.slowSqlMillis\\=5000\n      datasource:\n          # 主库数据源\n          master:\n            driver-class-name: com.mysql.cj.jdbc.Driver\n            url: jdbc:mysql://localhost:3306/ry-cloud?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8\n            username: root\n            password: password\n\n# mybatis配置\nmybatis:\n    # 搜索指定包别名\n    typeAliasesPackage: com.ruoyi.photo\n    # 配置mapper的扫描，找到所有的mapper.xml映射文件\n    mapperLocations: classpath:mapper/**/*.xml\n\n# springdoc配置\nspringdoc:\n  gatewayUrl: http://localhost:8080/${spring.application.name}\n  api-docs:\n    # 是否开启接口文档\n    enabled: true\n  info:\n    # 标题\n    title: ''PhotoNest摄影业务模块接口文档''\n    # 描述\n    description: ''PhotoNest摄影业务模块接口描述''\n    # 作者信息\n    contact:\n      name: PhotoNest\n      url: https://ruoyi.vip\n',
  sysdate(),
  sysdate(),
  'photonest',
  '127.0.0.1',
  '',
  '',
  'PhotoNest摄影业务模块',
  NULL,
  NULL,
  'yaml',
  NULL,
  ''
)
ON DUPLICATE KEY UPDATE
  content = VALUES(content),
  gmt_modified = sysdate(),
  c_desc = VALUES(c_desc),
  type = VALUES(type);
