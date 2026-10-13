const { maskPhone } = require('../../../utils/phone')

Page({
  data: {
    bookings: []
  },

  onLoad() {
    this.setData({
      bookings: [].map((item) => ({
        ...item,
        maskedPhone: maskPhone(item.phone)
      }))
    })
  }
})
