import { ensureWechatLogin } from '../api/auth'
import { resolveShareCode, getStoredShareCode } from './shareCode'

export async function prepareGuestPage(options = {}) {
  const shareCode = resolveShareCode(options) || getStoredShareCode()
  if (!shareCode) {
    uni.showToast({ title: '缺少摄影师分享码', icon: 'none' })
    return ''
  }
  await ensureWechatLogin(shareCode)
  return shareCode
}
