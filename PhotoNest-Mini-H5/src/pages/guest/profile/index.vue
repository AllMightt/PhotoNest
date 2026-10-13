<template>
  <view class="page">
    <view class="section">
      <view class="title">我的</view>
      <view class="muted">登录后查看预约记录和咨询状态。</view>
    </view>
    <view v-for="booking in bookings" :key="booking.id" class="section booking-card">
      <view class="work-title">{{ booking.bookingNo || '预约咨询' }}</view>
      <view class="muted">手机号：{{ maskPhone(booking.phone) }}</view>
      <view class="muted">状态：{{ statusText(booking.status) }}</view>
    </view>
    <view v-if="bookings.length === 0" class="section muted">暂无预约记录</view>
    <FloatingBooking />
  </view>
</template>

<script setup>
import { ref } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import FloatingBooking from '../../../components/FloatingBooking.vue'
import { maskPhone } from '../../../utils/phone'
import { prepareGuestPage } from '../../../utils/authGuard'

const bookings = ref([])

onLoad(async (options) => {
  await prepareGuestPage(options)
})

function statusText(status) {
  return ({ 0: '待跟进', 1: '已联系', 2: '已完成', 3: '已取消' })[status] || '待跟进'
}
</script>
