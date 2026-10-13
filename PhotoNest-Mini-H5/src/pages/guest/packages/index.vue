<template>
  <view class="page">
    <view class="title">套系</view>
    <view v-for="item in packages" :key="item.id" class="section package-card" @tap="goDetail(item)">
      <image v-if="item.coverUrl" class="package-cover" :src="item.coverUrl" mode="aspectFill" />
      <view class="package-title">{{ item.packageName }}</view>
      <view class="muted">{{ priceText(item) }}</view>
      <view class="primary-button" style="margin-top:20rpx" @tap.stop="goBooking(item)">预约这个套系</view>
    </view>
    <FloatingBooking />
  </view>
</template>

<script setup>
import { ref } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import FloatingBooking from '../../../components/FloatingBooking.vue'
import { getPackages } from '../../../api/guest'
import { prepareGuestPage } from '../../../utils/authGuard'

const shareCode = ref('')
const packages = ref([])

onLoad(async (options) => {
  shareCode.value = await prepareGuestPage(options)
  const response = await getPackages(shareCode.value, { pageNum: 1, pageSize: 20 })
  packages.value = response.rows || response.data?.rows || []
})

function priceText(item) {
  if (item.priceDisplayType === 'text') return item.priceText || '到店咨询'
  if (item.priceDisplayType === 'fixed') return item.price ? `¥${item.price}` : '到店咨询'
  if (item.priceDisplayType === 'deposit') return item.depositAmount ? `定金 ¥${item.depositAmount}` : '定金咨询'
  return item.priceText || '面议'
}

function goDetail(item) {
  uni.navigateTo({ url: `/pages/guest/package-detail/index?shareCode=${shareCode.value}&id=${item.id}` })
}

function goBooking(item) {
  uni.navigateTo({ url: `/pages/guest/booking/index?shareCode=${shareCode.value}&packageId=${item.id}` })
}
</script>
