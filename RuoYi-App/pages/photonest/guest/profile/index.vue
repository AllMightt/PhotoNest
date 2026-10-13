<template>
  <view class="pn-page">
    <view class="pn-section">
      <view class="pn-title">我的</view>
      <view class="pn-muted">登录后展示预约记录和咨询状态。当前 MVP 暂不做关注/收藏。</view>
    </view>
    <view v-for="booking in bookings" :key="booking.id" class="pn-section">
      <view class="pn-card-title">{{ booking.bookingNo || '预约咨询' }}</view>
      <view class="pn-muted">手机号：{{ maskPhone(booking.phone) }}</view>
      <view class="pn-muted">状态：{{ statusText(booking.status) }}</view>
    </view>
    <view v-if="bookings.length === 0" class="pn-section pn-muted">暂无预约记录</view>
    <FloatingBooking />
  </view>
</template>

<script>
import FloatingBooking from '@/pages/photonest/components/FloatingBooking.vue'
import { maskPhone } from '@/utils/photonest/phone'
import { resolveShareCode } from '@/utils/photonest/shareCode'

export default {
  components: { FloatingBooking },
  data() {
    return {
      shareCode: '',
      bookings: []
    }
  },
  onLoad(options) {
    this.shareCode = resolveShareCode(options)
  },
  methods: {
    maskPhone,
    statusText(status) {
      return ({ 0: '待跟进', 1: '已联系', 2: '已完成', 3: '已取消' })[status] || '待跟进'
    }
  }
}
</script>

<style lang="scss">
@import '@/pages/photonest/styles.scss';
</style>
