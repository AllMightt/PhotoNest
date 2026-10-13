const { createBooking } = require('../../../api/guest')
const { prepareGuestPage } = require('../../../utils/auth-guard')

Page({
  data: {
    shareCode: '',
    submitted: false,
    shootTypes: ['写真', '领证', '百天', '周岁', '婚礼', '订婚', '孕照', '亲子', '活动', '其他'],
    shootTypeIndex: -1,
    selectedTime: '',
    today: '',
    form: {
      customerName: '',
      phone: '',
      wechatId: '',
      packageId: '',
      shootType: '',
      expectedDate: '',
      expectedTime: '',
      expectedLocation: '',
      remark: '',
      requirement: '',
      sourceChannel: 'miniapp',
      sourcePage: 'booking',
      sourceType: 'page',
      sourcePackageId: '',
      sourceWorkId: ''
    }
  },

  async onLoad(options) {
    const shareCode = await prepareGuestPage(options)
    const form = { ...this.data.form }
    if (options.packageId) {
      form.packageId = options.packageId
      form.sourceType = 'package'
      form.sourcePackageId = options.packageId
    }
    if (options.workId) {
      form.sourceType = 'work'
      form.sourceWorkId = options.workId
    }
    this.setData({
      shareCode,
      form,
      today: formatDate(new Date())
    })
  },

  changeShootType(event) {
    const index = Number(event.detail.value)
    this.setData({
      shootTypeIndex: index,
      'form.shootType': this.data.shootTypes[index] || ''
    })
  },

  changeExpectedDate(event) {
    this.setData({ 'form.expectedDate': event.detail.value })
  },

  changeExpectedTime(event) {
    this.setData({
      selectedTime: event.detail.value,
      'form.expectedTime': event.detail.value
    })
  },

  changeInput(event) {
    const field = event.currentTarget.dataset.field
    this.setData({ [`form.${field}`]: event.detail.value })
  },

  async submit() {
    const form = this.data.form
    const required = ['shootType', 'expectedDate', 'expectedTime', 'phone', 'expectedLocation', 'customerName']
    if (required.some((key) => !form[key])) {
      wx.showToast({ title: '请填写必填信息', icon: 'none' })
      return
    }
    await createBooking(this.data.shareCode, {
      ...form,
      requirement: form.remark,
      sourceType: form.sourceType || 'page'
    })
    this.setData({ submitted: true })
  },

  confirmSuccess() {
    wx.switchTab({ url: '/pages/guest/home/index' })
  }
})

function formatDate(date) {
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  return `${year}-${month}-${day}`
}
