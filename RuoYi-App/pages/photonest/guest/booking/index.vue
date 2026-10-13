<template>
  <view class="pn-page">
    <view class="pn-title">预约咨询</view>
    <view class="pn-section">
      <view class="pn-form-item"><input v-model="form.customerName" class="pn-input" placeholder="姓名 *" /></view>
      <view class="pn-form-item"><input v-model="form.phone" class="pn-input" placeholder="电话 *" type="number" /></view>
      <view class="pn-form-item"><input v-model="form.wechatId" class="pn-input" placeholder="微信 *" /></view>
      <view class="pn-form-item"><input v-model="form.packageId" class="pn-input" placeholder="套系 ID *" /></view>
      <view class="pn-form-item"><input v-model="form.expectedDate" class="pn-input" placeholder="档期，例如 2026-06-18 *" /></view>
      <view class="pn-form-item"><input v-model="form.budget" class="pn-input" placeholder="预算（选填）" /></view>
      <view class="pn-form-item"><input v-model="form.sourceChannel" class="pn-input" placeholder="来源（选填）" /></view>
      <view class="pn-form-item"><textarea v-model="form.requirement" class="pn-textarea" placeholder="需求备注（选填）" /></view>
      <view class="pn-primary" @click="submit">提交预约</view>
    </view>
  </view>
</template>

<script>
import { createBooking } from '@/api/photonest/guest'
import { resolveShareCode } from '@/utils/photonest/shareCode'

export default {
  data() {
    return {
      shareCode: '',
      form: {
        customerName: '',
        phone: '',
        wechatId: '',
        packageId: '',
        expectedDate: '',
        budget: '',
        sourceChannel: '',
        requirement: '',
        sourcePage: 'booking'
      }
    }
  },
  onLoad(options) {
    this.shareCode = resolveShareCode(options)
    if (options.packageId) {
      this.form.packageId = options.packageId
    }
  },
  methods: {
    submit() {
      const required = ['customerName', 'phone', 'wechatId', 'packageId', 'expectedDate']
      if (required.some(key => !this.form[key])) {
        uni.showToast({ title: '请填写必填信息', icon: 'none' })
        return
      }
      createBooking(this.shareCode, Object.assign({}, this.form)).then(() => {
        uni.showToast({ title: '预约已提交' })
        setTimeout(() => {
          uni.navigateTo({ url: `/pages/photonest/guest/profile/index?shareCode=${this.shareCode}` })
        }, 600)
      })
    }
  }
}
</script>

<style lang="scss">
@import '@/pages/photonest/styles.scss';
</style>
