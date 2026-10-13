# PhotoNest-Photographer-Web

摄影师网页工作台。项目独立于若依管理员后台，适合单独部署、回滚和排障。

## Commands

```bash
npm install
npm run dev
npm run build
npm test
```

## Deployment

- 构建产物在 `dist`，可部署到独立静态站点。
- 开发环境 API 默认走 `/dev-api` 并代理到 `http://localhost:8080`。
- 生产环境通过 `VITE_APP_BASE_API` 指向 `ruoyi-cloud` API 网关。

## Scope

- 品牌主页配置。
- 摄影师自己的作品分类顺序维护。
- 作品、套系、预约列表。
- 摄影师端手机号展示默认脱敏。
