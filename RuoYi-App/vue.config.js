const path = require('path')

module.exports = {
  devServer: {
    host: '127.0.0.1',
    port: 9090,
    proxy: {
      '/code': {
        target: 'http://localhost:8080',
        changeOrigin: true
      },
      '/auth': {
        target: 'http://localhost:8080',
        changeOrigin: true
      },
      '/system': {
        target: 'http://localhost:8080',
        changeOrigin: true
      },
      '/photo': {
        target: 'http://localhost:8080',
        changeOrigin: true
      }
    }
  },
  chainWebpack(config) {
    const vueRule = config.module.rule('vue')
    vueRule.uses.store.forEach((use) => {
      if (use.get('loader') && use.get('loader').includes('vue-loader')) {
        use.tap((options = {}) => ({
          ...options,
          compiler: require('@dcloudio/uni-template-compiler')
        }))
      }
    })

    config.module
      .rule('fix-uni-template-exports')
      .resourceQuery(/type=template/)
      .enforce('post')
      .use('fix-uni-template-exports-loader')
      .loader(path.resolve(__dirname, 'build/fix-uni-template-exports-loader.js'))
  }
}
