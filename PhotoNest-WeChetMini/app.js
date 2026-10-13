const { resolveShareCode } = require('./utils/share-code')

App({
  globalData: {
    shareCode: ''
  },

  onLaunch(options) {
    this.globalData.shareCode = resolveShareCode(options.query || {})
  }
})
