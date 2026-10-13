<template>
  <view class="pn-page">
    <view class="pn-section">
      <view class="pn-title">预约管理</view>
      <view class="pn-muted">摄影师移动端轻量查看预约和咨询状态。</view>
    </view>
    <view v-for="booking in bookings" :key="booking.id" class="pn-section">
      <view class="pn-card-title">{{ booking.customerName }}</view>
      <view class="pn-muted">电话：{{ maskPhone(booking.phone) }}</view>
      <view class="pn-muted">微信：{{ booking.wechatId }}</view>
      <view class="pn-muted">状态：{{ booking.status || '待跟进' }}</view>
    </view>
  </view>
</template>

<script>
import { maskPhone } from '@/utils/photonest/phone'

export default {
  data() {
    return {
      bookings: []
    }
  },
  methods: {
    maskPhone
  }
}
</script>

<style lang="scss">
@import '@/pages/photonest/styles.scss';
</style>
