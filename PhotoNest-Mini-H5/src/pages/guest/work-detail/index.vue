<template>
  <view class="page">
    <view class="detail-nav" @tap="goBack">‹ 返回</view>
    <view class="section">
      <view class="title">{{ work.title }}</view>
      <view class="muted" v-if="work.shootLocation">拍摄地点：{{ work.shootLocation }}</view>
      <view class="muted" v-if="work.shootTime">拍摄时间：{{ work.shootTime }}</view>
      <view class="muted">{{ work.description || '这组照片记录了一次值得珍藏的拍摄。' }}</view>
    </view>
    <image
      v-for="image in images"
      :key="image.id"
      class="detail-image"
      :src="image.displayUrl || image.originalUrl || image.thumbnailUrl"
      mode="widthFix"
    />
    <FloatingBooking />
  </view>
</template>

<script setup>
import { ref } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import FloatingBooking from '../../../components/FloatingBooking.vue'
import { getWorkDetail } from '../../../api/guest'
import { prepareGuestPage } from '../../../utils/authGuard'

const shareCode = ref('')
const work = ref({})
const images = ref([])

onLoad(async (options) => {
  shareCode.value = await prepareGuestPage(options)
  const response = await getWorkDetail(shareCode.value, options.id)
  const data = response.data || response
  work.value = data.work || {}
  images.value = data.images || []
})

function goBack() {
  uni.navigateBack()
}
</script>
