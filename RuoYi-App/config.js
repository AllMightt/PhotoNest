const devLanHost = '172.20.10.3'

function resolveBaseUrl() {
  if (process.env.NODE_ENV === 'development') {
    // H5 本地开发走 devServer 代理，直接请求 /code、/auth 等真实后端路径。
    // 这样可以避免开发代理前缀重写异常导致验证码接口请求到错误地址。
    // #ifdef H5
    return ''
    // #endif
  }

  // H5 开发时跟随当前访问域名：localhost:9090 -> localhost:8080，
  // 局域网访问 172.20.10.3:9090 -> 172.20.10.3:8080。
  if (typeof window !== 'undefined' && window.location && window.location.hostname) {
    const { protocol, hostname } = window.location
    return `${protocol}//${hostname}:8080`
  }

  // 微信开发者工具/手机端没有 window，开发阶段需要访问电脑局域网 IP。
  return `http://${devLanHost}:8080`
}

// 应用全局配置
module.exports = {
  // baseUrl: 'https://vue.ruoyi.vip/prod-api',
  baseUrl: resolveBaseUrl(),
  // 应用信息
  appInfo: {
    // 应用名称
    name: "ruoyi-app",
    // 应用版本
    version: "1.2.0",
    // 应用logo
    logo: "/static/logo.png",
    // 官方网站
    site_url: "http://ruoyi.vip",
    // 政策协议
    agreements: [{
        title: "隐私政策",
        url: "https://ruoyi.vip/protocol.html"
      },
      {
        title: "用户服务协议",
        url: "https://ruoyi.vip/protocol.html"
      }
    ]
  }
}
