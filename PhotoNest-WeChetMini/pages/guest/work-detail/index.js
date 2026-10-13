const { getWorkDetail } = require('../../../api/guest')
const { prepareGuestPage } = require('../../../utils/auth-guard')
const { normalizeImageFields } = require('../../../utils/file-url')

Page({
  data: {
    shareCode: '',
    workId: '',
    work: {},
    images: [],
    coverUrl: '',
    imageCount: 0,
    previewUrls: []
  },

  async onLoad(options) {
    const shareCode = await prepareGuestPage(options)
    const response = await getWorkDetail(shareCode, options.id)
    const data = response.data || response
    const work = normalizeImageFields(data.work || {}, ['coverUrl'])
    const images = (data.images || []).map((item) => normalizeImageFields(item, ['originalUrl', 'displayUrl', 'thumbnailUrl', 'watermarkUrl']))
    const previewUrls = images
      .map((item) => item.displayUrl || item.originalUrl || item.thumbnailUrl)
      .filter((url) => !!url)
    this.setData({
      shareCode,
      workId: options.id,
      work,
      images,
      coverUrl: work.coverUrl || previewUrls[0] || '',
      imageCount: images.length,
      previewUrls
    })
  },

  goBooking() {
    wx.navigateTo({ url: `/pages/guest/booking/index?shareCode=${this.data.shareCode}&workId=${this.data.workId}` })
  },

  previewCover() {
    const urls = this.data.previewUrls.length ? this.data.previewUrls : [this.data.coverUrl]
    wx.previewImage({
      current: this.data.coverUrl,
      urls
    })
  },

  previewImage(event) {
    const index = event.currentTarget.dataset.index
    const current = this.data.previewUrls[index]
    if (!current) return
    wx.previewImage({
      current,
      urls: this.data.previewUrls
    })
  }
})
