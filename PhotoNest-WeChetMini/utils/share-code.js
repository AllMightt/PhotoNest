const config = require('./config')

const STORAGE_KEY = 'photonest.shareCode'

function resolveShareCode(options = {}) {
  const raw = options.shareCode || options.scene || options.s
  const shareCode = raw ? decodeURIComponent(raw) : ''
  if (shareCode) {
    wx.setStorageSync(STORAGE_KEY, shareCode)
    return shareCode
  }
  return wx.getStorageSync(STORAGE_KEY) || config.defaultShareCode || ''
}

function getStoredShareCode() {
  return wx.getStorageSync(STORAGE_KEY) || config.defaultShareCode || ''
}

module.exports = {
  resolveShareCode,
  getStoredShareCode
}
