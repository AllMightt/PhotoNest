<template>
  <view class="page">
    <view class="section">
      <view class="title">预约管理</view>
      <view class="muted">摄影师移动端轻量查看预约和咨询状态。</view>
    </view>
    <view v-for="booking in bookings" :key="booking.id" class="section booking-card">
      <view class="work-title">{{ booking.customerName }}</view>
      <view class="muted">电话：{{ maskPhone(booking.phone) }}</view>
      <view class="muted">微信：{{ booking.wechatId }}</view>
      <view class="muted">状态：{{ booking.status || '待跟进' }}</view>
    </view>
  </view>
</template>

<script setup>
import { ref } from 'vue'
import { maskPhone } from '../../../utils/phone'

const bookings = ref([])
</script>
