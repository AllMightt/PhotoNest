const STORAGE_KEY = 'photonest.shareCode'

export function resolveShareCode(options = {}) {
  const shareCode = options.shareCode || options.scene || options.s
  if (shareCode) {
    uni.setStorageSync(STORAGE_KEY, shareCode)
    return shareCode
  }
  return uni.getStorageSync(STORAGE_KEY) || ''
}

export function getStoredShareCode() {
  return uni.getStorageSync(STORAGE_KEY) || ''
}
