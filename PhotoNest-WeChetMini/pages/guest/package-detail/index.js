const { getPackageDetail } = require('../../../api/guest')
const { prepareGuestPage } = require('../../../utils/auth-guard')
const { normalizeImageFields } = require('../../../utils/file-url')

Page({
  data: {
    shareCode: '',
    packageId: '',
    pkg: {},
    items: [],
    priceLabel: ''
  },

  async onLoad(options) {
    const shareCode = await prepareGuestPage(options)
    const response = await getPackageDetail(shareCode, options.id)
    const data = response.data || response
    const pkg = normalizeImageFields(data.package || {}, ['coverUrl'])
    this.setData({
      shareCode,
      packageId: options.id,
      pkg,
      items: data.items || [],
      priceLabel: priceText(pkg)
    })
  },

  goBooking() {
    wx.navigateTo({ url: `/pages/guest/booking/index?shareCode=${this.data.shareCode}&packageId=${this.data.packageId}` })
  },

  goBack() {
    wx.navigateBack()
  }
})

function priceText(item) {
  if (item.priceDisplayType === 'text') return item.priceText || '到店咨询'
  if (item.priceDisplayType === 'fixed') return item.price ? `¥${item.price}` : '到店咨询'
  if (item.priceDisplayType === 'deposit') return item.depositAmount ? `定金 ¥${item.depositAmount}` : '定金咨询'
  return item.priceText || '面议'
}
