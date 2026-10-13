const { getAbout } = require('../../api/guest')
const { normalizeImageFields } = require('../../utils/file-url')

Component({
  properties: {
    shareCode: {
      type: String,
      value: ''
    }
  },

  data: {
    contact: {},
    loadedShareCode: ''
  },

  observers: {
    shareCode(value) {
      if (value) {
        this.loadContact(value)
      }
    }
  },

  pageLifetimes: {
    show() {
      if (this.data.shareCode) {
        this.loadContact(this.data.shareCode)
      }
    }
  },

  methods: {
    async loadContact(shareCode) {
      if (this.data.loadedShareCode === shareCode && this.data.contact.brandName) {
        return
      }
      try {
        const response = await getAbout(shareCode)
        const contact = normalizeImageFields(response.data || response || {}, ['coverImage', 'logoUrl'])
        this.setData({ contact, loadedShareCode: shareCode })
      } catch (error) {
        this.setData({ loadedShareCode: '' })
      }
    },

    copyWechat() {
      this.copyAccountValue('微信', this.data.contact.wechatId)
    },

    copyAccount(event) {
      const type = event.currentTarget.dataset.type
      const contact = this.data.contact
      const map = {
        phone: { label: '电话', value: contact.phone },
        wechat: { label: '微信', value: contact.wechatId },
        xiaohongshu: { label: '小红书', value: contact.xiaohongshuId },
        douyin: { label: '抖音', value: contact.douyinId }
      }
      const item = map[type]
      if (!item) return
      this.copyAccountValue(item.label, item.value)
    },

    copyAccountValue(platform, value) {
      if (!value) {
        wx.showToast({ title: `摄影师暂未配置${platform}`, icon: 'none' })
        return
      }
      wx.setClipboardData({
        data: value,
        success: () => {
          wx.showModal({
            title: '复制账号成功',
            content: `请切换到${platform}搜索`,
            showCancel: false,
            confirmText: '知道了'
          })
        }
      })
    }
  }
})
