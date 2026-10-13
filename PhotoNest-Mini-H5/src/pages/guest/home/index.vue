<template>
  <view class="page">
    <view class="section">
      <view class="title">{{ brand.brandName || photographer.brandName || 'PhotoNest' }}</view>
      <view class="muted">{{ brand.subtitle || photographer.photographerName }}</view>
    </view>

    <image v-if="coverImage" class="hero-image" :src="coverImage" mode="aspectFill" />

    <view class="section">
      <view class="eyebrow">About Us</view>
      <view class="title">关于我们</view>
      <view class="muted">{{ brand.aboutContent || brand.intro || '用影像记录重要时刻。' }}</view>
      <view style="display:flex;gap:20rpx;margin-top:28rpx">
        <view class="primary-button" style="flex:1" @tap="goBooking">预约咨询</view>
        <view class="ghost-button" style="flex:1" @tap="copyWechat">添加客服</view>
      </view>
    </view>

    <view class="section">
      <view class="eyebrow">Gallery</view>
      <view class="title">作品展示</view>
      <view class="grid">
        <view v-for="work in homeWorks" :key="work.id" class="work-card" @tap="goWork(work)">
          <image class="work-cover" :src="work.coverUrl" mode="aspectFill" />
          <view class="work-title">{{ work.title }}</view>
          <view class="muted">#作品欣赏</view>
        </view>
        <view v-if="needsPlaceholder" class="placeholder-card" />
      </view>
      <view v-if="homeWorks.length >= 8" class="more-button" style="margin-top:34rpx" @tap="goWorks">MORE</view>
    </view>

    <view class="section contact-section">
      <view class="muted">微信：{{ brand.wechatId || photographer.wechatId || '暂未配置' }}</view>
      <view class="muted">电话：{{ photographer.phone || '暂未配置' }}</view>
      <view class="muted">地址：{{ photographer.city || '暂未配置' }}</view>
    </view>

    <FloatingBooking />
  </view>
</template>

<script setup>
import { computed, ref } from 'vue'
import { onLoad, onShow } from '@dcloudio/uni-app'
import FloatingBooking from '../../../components/FloatingBooking.vue'
import { getHome } from '../../../api/guest'
import { prepareGuestPage } from '../../../utils/authGuard'

const shareCode = ref('')
const photographer = ref({})
const brand = ref({})
const homeWorks = ref([])

const coverImage = computed(() => brand.value.coverImage || photographer.value.coverImage)
const needsPlaceholder = computed(() => homeWorks.value.length % 2 === 1)

onLoad(async (options) => {
  shareCode.value = await prepareGuestPage(options)
  await loadHome()
})

onShow(() => {
  const shouldRestore = uni.getStorageSync('photonest.restoreHomeScroll')
  const y = uni.getStorageSync('photonest.homeScrollTop')
  if (shouldRestore && y) {
    uni.removeStorageSync('photonest.restoreHomeScroll')
    setTimeout(() => uni.pageScrollTo({ scrollTop: y, duration: 0 }), 0)
  }
})

async function loadHome() {
  const response = await getHome(shareCode.value)
  const data = response.data || response
  photographer.value = data.photographer || {}
  brand.value = data.brandConfig || {}
  homeWorks.value = (data.homeWorks || []).slice(0, 8)
}

function goWork(work) {
  uni.createSelectorQuery().selectViewport().scrollOffset(({ scrollTop }) => {
    uni.setStorageSync('photonest.homeScrollTop', scrollTop)
    uni.setStorageSync('photonest.restoreHomeScroll', '1')
    uni.navigateTo({ url: `/pages/guest/work-detail/index?shareCode=${shareCode.value}&id=${work.id}` })
  }).exec()
}

function goWorks() {
  uni.switchTab({ url: '/pages/guest/works/index' })
}

function goBooking() {
  uni.navigateTo({ url: `/pages/guest/booking/index?shareCode=${shareCode.value}` })
}

function copyWechat() {
  const wechat = brand.value.wechatId || photographer.value.wechatId
  if (!wechat) {
    uni.showToast({ title: '摄影师暂未配置微信', icon: 'none' })
    return
  }
  uni.setClipboardData({ data: wechat })
}
</script>
