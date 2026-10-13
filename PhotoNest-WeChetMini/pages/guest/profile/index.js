const { prepareGuestPage } = require('../../../utils/auth-guard')
const { maskPhone } = require('../../../utils/phone')

Page({
  data: {
    shareCode: '',
    bookings: []
  },

  async onLoad(options) {
    const shareCode = await prepareGuestPage(options)
    this.setData({
      shareCode,
      bookings: [].map((item) => ({
        ...item,
        maskedPhone: maskPhone(item.phone),
        statusLabel: statusText(item.status)
      }))
    })
  }
})

function statusText(status) {
  return ({ 0: '待跟进', 1: '已联系', 2: '已完成', 3: '已取消' })[status] || '待跟进'
}
