const { getAbout } = require('../../../api/guest')
const { prepareGuestPage } = require('../../../utils/auth-guard')
const { normalizeImageFields } = require('../../../utils/file-url')

Page({
  data: {
    shareCode: '',
    about: {}
  },

  async onLoad(options) {
    const shareCode = await prepareGuestPage(options)
    const response = await getAbout(shareCode)
    this.setData({
      shareCode,
      about: normalizeImageFields(response.data || response || {}, ['logoUrl', 'coverImage', 'wechatQr', 'xiaohongshuQr', 'douyinQr'])
    })
  }
})
