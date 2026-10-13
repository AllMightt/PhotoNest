# PhotoNest-Mini-H5

客人端微信小程序 + H5，以及摄影师移动端轻量能力。项目独立构建、独立部署，不影响 `RuoYi-Cloud-Vue3` 管理后台。

## Commands

```bash
npm install
npm run dev:h5
npm run build:h5
npm run build:mp-weixin
npm test
```

## Deployment

- H5 构建产物在 `dist/build/h5`，可部署到独立静态站点。
- 微信小程序构建产物在 `dist/build/mp-weixin`，用微信开发者工具打开后上传体验版/审核版/正式版。
- 后端 API 默认走 `/dev-api`，生产环境通过 `VITE_APP_BASE_API` 指向 API 网关。

## Scope

- 客人必须微信登录后进入小程序。
- 客人通过 `shareCode` 只能查看对应摄影师内容。
- MVP 不做作品搜索、关注、收藏。
- 数据库存储正常手机号，前端展示给摄影师时使用中间 `*` 脱敏。
