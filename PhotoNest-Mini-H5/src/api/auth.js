import { request } from './request'

export function loginByWechat(code, shareCode) {
  return request({
    url: '/photo/app/auth/wechat-login',
    method: 'POST',
    data: { code, shareCode }
  })
}

export function ensureWechatLogin(shareCode) {
  const existingToken = uni.getStorageSync('photonest.token')
  const tokenShareCode = uni.getStorageSync('photonest.token.shareCode')
  if (existingToken && tokenShareCode === shareCode) {
    return Promise.resolve(existingToken)
  }

  return new Promise((resolve, reject) => {
    const doLogin = async (code) => {
      try {
        const response = await loginByWechat(code, shareCode)
        const data = response.data || response
        const token = data.access_token || data.token
        if (!token) {
          reject(new Error('登录失败'))
          return
        }
        uni.setStorageSync('photonest.token', token)
        uni.setStorageSync('photonest.token.shareCode', shareCode)
        resolve(token)
      } catch (error) {
        reject(error)
      }
    }

    uni.login({
      provider: 'weixin',
      success: ({ code }) => doLogin(code),
      fail: () => doLogin(`dev-${Date.now()}`)
    })
  })
}

export function clearWechatLogin() {
  uni.removeStorageSync('photonest.token')
  uni.removeStorageSync('photonest.token.shareCode')
}
