const config = require('../utils/config')

function request({ url, method = 'GET', data, params, header = {}, quiet = false }) {
  const query = params ? `?${buildQuery(params)}` : ''
  const token = wx.getStorageSync('photonest.token')

  return new Promise((resolve, reject) => {
    wx.request({
      url: `${config.baseUrl}${url}${query}`,
      method,
      data,
      header: {
        Authorization: token ? `Bearer ${token}` : '',
        ...header
      },
      success(response) {
        const body = response.data
        if (response.statusCode >= 200 && response.statusCode < 300) {
          if (body && body.code && body.code !== 200) {
            if (body.code === 401 || isAuthError(body.msg)) {
              clearLogin()
            }
            showError(body.msg || '请求失败', quiet)
            reject(body)
            return
          }
          resolve(body)
          return
        }
        showError((body && body.msg) || '请求失败', quiet)
        reject(body || response)
      },
      fail(error) {
        showError('网络请求失败，请确认本地后端已启动', quiet)
        reject(error)
      }
    })
  })
}

function buildQuery(params) {
  return Object.keys(params)
    .filter((key) => params[key] !== undefined && params[key] !== null && params[key] !== '')
    .map((key) => `${encodeURIComponent(key)}=${encodeURIComponent(params[key])}`)
    .join('&')
}

function showError(title, quiet) {
  if (!quiet) {
    wx.showToast({ title, icon: 'none' })
  }
}

function isAuthError(message = '') {
  return message.includes('请先登录') || message.includes('无权访问') || message.includes('登录')
}

function clearLogin() {
  wx.removeStorageSync('photonest.token')
  wx.removeStorageSync('photonest.token.shareCode')
  wx.removeStorageSync('photonest.token.createdAt')
}

module.exports = {
  request
}
