<template>
  <view class="page">
    <view class="detail-nav" @tap="goBack">‹ 返回</view>
    <view class="section">
      <image v-if="pkg.coverUrl" class="package-cover large-cover" :src="pkg.coverUrl" mode="aspectFill" />
      <view class="title">{{ pkg.packageName }}</view>
      <view class="muted">{{ priceText(pkg) }}</view>
      <view class="muted" v-if="pkg.durationMinutes">拍摄时长：{{ pkg.durationMinutes }} 分钟</view>
      <view class="muted" v-if="pkg.originalPhotoCount">底片数量：{{ pkg.originalPhotoCount }}</view>
      <view class="muted" v-if="pkg.retouchPhotoCount">精修数量：{{ pkg.retouchPhotoCount }}</view>
    </view>

    <view class="section" v-if="items.length">
      <view class="work-title">套系明细</view>
      <view v-for="item in items" :key="item.id" class="package-item">
        <view>{{ item.itemName }}</view>
        <view class="muted">{{ item.itemValue || item.remark }}</view>
      </view>
    </view>

    <view class="primary-button" @tap="goBooking">预约这个套系</view>
    <FloatingBooking />
  </view>
</template>

<script setup>
import { ref } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import FloatingBooking from '../../../components/FloatingBooking.vue'
import { getPackageDetail } from '../../../api/guest'
import { prepareGuestPage } from '../../../utils/authGuard'

const shareCode = ref('')
const packageId = ref('')
const pkg = ref({})
const items = ref([])

onLoad(async (options) => {
  shareCode.value = await prepareGuestPage(options)
  packageId.value = options.id
  const response = await getPackageDetail(shareCode.value, packageId.value)
  const data = response.data || response
  pkg.value = data.package || {}
  items.value = data.items || []
})

function priceText(item) {
  if (item.priceDisplayType === 'text') return item.priceText || '到店咨询'
  if (item.priceDisplayType === 'fixed') return item.price ? `¥${item.price}` : '到店咨询'
  if (item.priceDisplayType === 'deposit') return item.depositAmount ? `定金 ¥${item.depositAmount}` : '定金咨询'
  return item.priceText || '面议'
}

function goBooking() {
  uni.navigateTo({ url: `/pages/guest/booking/index?shareCode=${shareCode.value}&packageId=${packageId.value}` })
}

function goBack() {
  uni.navigateBack()
}
</script>
