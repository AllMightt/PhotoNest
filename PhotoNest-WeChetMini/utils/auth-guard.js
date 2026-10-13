const { ensureWechatLogin } = require('../api/auth')
const { resolveShareCode, getStoredShareCode } = require('./share-code')

async function prepareGuestPage(options = {}) {
  const shareCode = resolveShareCode(options) || getStoredShareCode()
  if (!shareCode) {
    wx.showToast({ title: '缺少摄影师分享码', icon: 'none' })
    return ''
  }
  await ensureWechatLogin(shareCode)
  return shareCode
}

module.exports = {
  prepareGuestPage
}
