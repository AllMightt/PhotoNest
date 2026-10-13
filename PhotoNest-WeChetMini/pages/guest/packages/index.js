const { getPackages } = require('../../../api/guest')
const { prepareGuestPage } = require('../../../utils/auth-guard')
const { normalizeImageFields } = require('../../../utils/file-url')

Page({
  data: {
    shareCode: '',
    packages: []
  },

  async onLoad(options) {
    const shareCode = await prepareGuestPage(options)
    const response = await getPackages(shareCode, { pageNum: 1, pageSize: 20 })
    const packages = (response.rows || (response.data && response.data.rows) || [])
      .map((item) => ({ ...normalizeImageFields(item, ['coverUrl']), priceLabel: priceText(item) }))
    this.setData({ shareCode, packages })
  },

  goDetail(event) {
    const id = event.currentTarget.dataset.id
    wx.navigateTo({ url: `/pages/guest/package-detail/index?shareCode=${this.data.shareCode}&id=${id}` })
  },

  goBooking(event) {
    const id = event.currentTarget.dataset.id
    wx.navigateTo({ url: `/pages/guest/booking/index?shareCode=${this.data.shareCode}&packageId=${id}` })
  }
})

function priceText(item) {
  if (item.priceDisplayType === 'text') return item.priceText || '到店咨询'
  if (item.priceDisplayType === 'fixed') return item.price ? `¥${item.price}` : '到店咨询'
  if (item.priceDisplayType === 'deposit') return item.depositAmount ? `定金 ¥${item.depositAmount}` : '定金咨询'
  return item.priceText || '面议'
}
