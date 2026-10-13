const BASE_URL = import.meta.env.VITE_APP_BASE_API || '/dev-api'

export function request({ url, method = 'GET', data, params, header = {} }) {
  const query = params ? `?${new URLSearchParams(params).toString()}` : ''
  const token = uni.getStorageSync('photonest.token')

  return new Promise((resolve, reject) => {
    uni.request({
      url: `${BASE_URL}${url}${query}`,
      method,
      data,
      header: {
        Authorization: token ? `Bearer ${token}` : '',
        ...header
      },
      success(response) {
        const body = response.data
        if (response.statusCode >= 200 && response.statusCode < 300) {
          if (body && body.code === 401) {
            uni.removeStorageSync('photonest.token')
            uni.removeStorageSync('photonest.token.shareCode')
            uni.showToast({ title: body.msg || '请先登录', icon: 'none' })
            reject(body)
            return
          }
          resolve(body)
          return
        }
        reject(body || response)
      },
      fail: reject
    })
  })
}
