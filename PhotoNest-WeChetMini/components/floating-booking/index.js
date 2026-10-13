const { getStoredShareCode } = require('../../utils/share-code')

const BUTTON_SIZE = 58
const CONTACT_DOCK_HEIGHT = 178

Component({
  data: {
    x: 0,
    y: 0
  },

  lifetimes: {
    attached() {
      this.restorePosition()
    }
  },

  pageLifetimes: {
    show() {
      this.restorePosition()
    }
  },

  methods: {
    restorePosition() {
      const shareCode = getStoredShareCode()
      const cached = wx.getStorageSync(`photonest.bookingButton.${shareCode}`)
      if (cached && typeof cached.x === 'number' && typeof cached.y === 'number') {
        this.setData({ x: cached.x, y: cached.y })
        return
      }
      const info = wx.getSystemInfoSync()
      this.setData({
        x: Math.max(12, info.windowWidth - BUTTON_SIZE - 18),
        y: Math.max(80, info.windowHeight - BUTTON_SIZE - CONTACT_DOCK_HEIGHT - 132)
      })
    },

    openBooking() {
      const shareCode = getStoredShareCode()
      wx.navigateTo({ url: `/pages/guest/booking/index?shareCode=${shareCode}` })
    },

    savePosition(event) {
      const shareCode = getStoredShareCode()
      wx.setStorageSync(`photonest.bookingButton.${shareCode}`, {
        x: event.detail.x,
        y: event.detail.y
      })
    }
  }
})
