const { request } = require('./request')

function loginByWechat(code, shareCode) {
  return request({
    url: '/photo/app/auth/wechat-login',
    method: 'POST',
    data: { code, shareCode }
  })
}

function ensureWechatLogin(shareCode) {
  const existingToken = wx.getStorageSync('photonest.token')
  const tokenShareCode = wx.getStorageSync('photonest.token.shareCode')
  const createdAt = wx.getStorageSync('photonest.token.createdAt')
  const tokenAge = createdAt ? Date.now() - createdAt : Number.MAX_SAFE_INTEGER
  if (existingToken && tokenShareCode === shareCode && tokenAge < 30 * 60 * 1000) {
    return Promise.resolve(existingToken)
  }

  return new Promise((resolve, reject) => {
    const doLogin = async (code) => {
      try {
        const response = await loginByWechat(code, shareCode)
        const data = response.data || response
        const token = data.access_token || data.token
        if (!token) {
          wx.showToast({ title: '登录失败', icon: 'none' })
          reject(new Error('登录失败'))
          return
        }
        wx.setStorageSync('photonest.token', token)
        wx.setStorageSync('photonest.token.shareCode', shareCode)
        wx.setStorageSync('photonest.token.createdAt', Date.now())
        resolve(token)
      } catch (error) {
        reject(error)
      }
    }

    wx.login({
      success: ({ code }) => doLogin(code),
      fail: () => doLogin(`dev-${Date.now()}`)
    })
  })
}

function clearWechatLogin() {
  wx.removeStorageSync('photonest.token')
  wx.removeStorageSync('photonest.token.shareCode')
  wx.removeStorageSync('photonest.token.createdAt')
}

module.exports = {
  loginByWechat,
  ensureWechatLogin,
  clearWechatLogin
}
