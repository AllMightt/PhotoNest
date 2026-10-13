const { getHome } = require('../../../api/guest')
const { prepareGuestPage } = require('../../../utils/auth-guard')
const { normalizeFileUrl, normalizeImageFields } = require('../../../utils/file-url')

Page({
  data: {
    shareCode: '',
    photographer: {},
    brand: {},
    homeWorks: [],
    coverImage: '',
    needsPlaceholder: false
  },

  async onLoad(options) {
    const shareCode = await prepareGuestPage(options)
    this.setData({ shareCode })
    await this.loadHome()
  },

  onShow() {
    const shouldRestore = wx.getStorageSync('photonest.restoreHomeScroll')
    const y = wx.getStorageSync('photonest.homeScrollTop')
    if (shouldRestore && y) {
      wx.removeStorageSync('photonest.restoreHomeScroll')
      setTimeout(() => wx.pageScrollTo({ scrollTop: y, duration: 0 }), 0)
    }
  },

  async loadHome() {
    const response = await getHome(this.data.shareCode)
    const data = response.data || response
    const photographer = normalizeImageFields(data.photographer || {}, ['avatar', 'coverImage'])
    const brand = normalizeImageFields(data.brandConfig || {}, ['logoUrl', 'coverImage', 'wechatQr', 'xiaohongshuQr', 'douyinQr'])
    const homeWorks = (data.homeWorks || []).slice(0, 8).map((item) => normalizeImageFields(item, ['coverUrl']))
    this.setData({
      photographer,
      brand,
      homeWorks,
      coverImage: normalizeFileUrl(brand.coverImage || photographer.coverImage || ''),
      needsPlaceholder: homeWorks.length % 2 === 1
    })
  },

  goWork(event) {
    const id = event.currentTarget.dataset.id
    wx.createSelectorQuery().selectViewport().scrollOffset(({ scrollTop }) => {
      wx.setStorageSync('photonest.homeScrollTop', scrollTop)
      wx.setStorageSync('photonest.restoreHomeScroll', '1')
      wx.navigateTo({ url: `/pages/guest/work-detail/index?shareCode=${this.data.shareCode}&id=${id}` })
    }).exec()
  },

  goWorks() {
    wx.removeStorageSync('photonest.worksActiveCategoryId')
    wx.removeStorageSync('photonest.worksScrollTop')
    wx.removeStorageSync('photonest.restoreWorksScroll')
    wx.setStorageSync('photonest.resetWorksFromHome', '1')
    wx.switchTab({ url: '/pages/guest/works/index' })
  },

  goAbout() {
    wx.switchTab({ url: '/pages/guest/about/index' })
  },

  goBooking() {
    wx.navigateTo({ url: `/pages/guest/booking/index?shareCode=${this.data.shareCode}` })
  },

  copyWechat() {
    const wechat = this.data.brand.wechatId || this.data.photographer.wechatId
    if (!wechat) {
      wx.showToast({ title: '摄影师暂未配置微信', icon: 'none' })
      return
    }
    wx.setClipboardData({ data: wechat })
  }
})
