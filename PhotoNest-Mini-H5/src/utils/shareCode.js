const STORAGE_KEY = 'photonest.shareCode'

export function resolveShareCode(options = {}) {
  const raw = options.shareCode || options.scene || options.s
  const shareCode = raw ? decodeURIComponent(raw) : ''
  if (shareCode) {
    uni.setStorageSync(STORAGE_KEY, shareCode)
    return shareCode
  }
  return uni.getStorageSync(STORAGE_KEY) || ''
}

export function getStoredShareCode() {
  return uni.getStorageSync(STORAGE_KEY) || ''
}
