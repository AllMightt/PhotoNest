<template>
  <view class="page">
    <view class="section">
      <view class="eyebrow">About</view>
      <view class="title">{{ about.brandName || '关于我们' }}</view>
      <image v-if="about.logoUrl" class="about-logo" :src="about.logoUrl" mode="aspectFit" />
      <view class="muted about-content">{{ about.aboutContent || about.intro || '用影像记录重要时刻。' }}</view>
    </view>

    <view class="section">
      <view class="work-title">联系方式</view>
      <view class="muted">微信：{{ about.wechatId || '暂未配置' }}</view>
      <view class="muted" v-if="about.xiaohongshuId">小红书：{{ about.xiaohongshuId }}</view>
      <view class="muted" v-if="about.douyinId">抖音：{{ about.douyinId }}</view>
      <image v-if="about.wechatQr" class="qr-image" :src="about.wechatQr" mode="aspectFit" />
    </view>

    <FloatingBooking />
  </view>
</template>

<script setup>
import { ref } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import FloatingBooking from '../../../components/FloatingBooking.vue'
import { getAbout } from '../../../api/guest'
import { prepareGuestPage } from '../../../utils/authGuard'

const shareCode = ref('')
const about = ref({})

onLoad(async (options) => {
  shareCode.value = await prepareGuestPage(options)
  const response = await getAbout(shareCode.value)
  about.value = response.data || response || {}
})
</script>
