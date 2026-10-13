<template>
  <view class="pn-page">
    <view class="pn-section">
      <view class="pn-title">{{ brand.brandName || photographer.brandName || 'PhotoNest' }}</view>
      <view class="pn-muted">{{ brand.subtitle || photographer.photographerName }}</view>
    </view>

    <image v-if="coverImage" class="pn-hero-image" :src="coverImage" mode="aspectFill" />

    <view class="pn-section">
      <view class="pn-eyebrow">About Us</view>
      <view class="pn-title">关于我们</view>
      <view class="pn-muted">{{ brand.aboutContent || brand.intro || '用影像记录重要时刻。' }}</view>
      <view style="display:flex;gap:20rpx;margin-top:28rpx">
        <view class="pn-primary" style="flex:1" @click="goBooking">预约咨询</view>
        <view class="pn-ghost" style="flex:1" @click="copyWechat">添加客服</view>
      </view>
    </view>

    <view class="pn-section">
      <view class="pn-eyebrow">Gallery</view>
      <view class="pn-title">作品展示</view>
      <view class="pn-grid">
        <view v-for="work in homeWorks" :key="work.id" @click="goWork(work)">
          <image class="pn-cover" :src="work.coverUrl" mode="aspectFill" />
          <view class="pn-card-title">{{ work.title }}</view>
          <view class="pn-muted">#作品欣赏</view>
        </view>
        <view v-if="needsPlaceholder" class="pn-placeholder" />
      </view>
      <view v-if="homeWorks.length >= 8" class="pn-more" style="margin-top:34rpx" @click="goWorks">MORE</view>
    </view>

    <FloatingBooking />
  </view>
</template>

<script>
import FloatingBooking from '@/pages/photonest/components/FloatingBooking.vue'
import { getHome } from '@/api/photonest/guest'
import { resolveShareCode } from '@/utils/photonest/shareCode'

export default {
  components: { FloatingBooking },
  data() {
    return {
      shareCode: '',
      photographer: {},
      brand: {},
      homeWorks: []
    }
  },
  computed: {
    coverImage() {
      return this.brand.coverImage || this.photographer.coverImage
    },
    needsPlaceholder() {
      return this.homeWorks.length % 2 === 1
    }
  },
  onLoad(options) {
    this.shareCode = resolveShareCode(options)
    this.loadHome()
  },
  onShow() {
    const y = uni.getStorageSync('photonest.homeScrollTop')
    if (y) {
      setTimeout(() => uni.pageScrollTo({ scrollTop: y, duration: 0 }), 0)
    }
  },
  methods: {
    loadHome() {
      getHome(this.shareCode).then(response => {
        const data = response.data || response
        this.photographer = data.photographer || {}
        this.brand = data.brandConfig || {}
        this.homeWorks = (data.homeWorks || []).slice(0, 8)
      })
    },
    goWork(work) {
      uni.createSelectorQuery().selectViewport().scrollOffset(({ scrollTop }) => {
        uni.setStorageSync('photonest.homeScrollTop', scrollTop)
        uni.navigateTo({ url: `/pages/photonest/guest/work-detail/index?shareCode=${this.shareCode}&id=${work.id}` })
      }).exec()
    },
    goWorks() {
      uni.navigateTo({ url: `/pages/photonest/guest/works/index?shareCode=${this.shareCode}` })
    },
    goBooking() {
      uni.navigateTo({ url: `/pages/photonest/guest/booking/index?shareCode=${this.shareCode}` })
    },
    copyWechat() {
      const wechat = this.brand.wechatId || this.photographer.wechatId
      if (!wechat) {
        uni.showToast({ title: '摄影师暂未配置微信', icon: 'none' })
        return
      }
      uni.setClipboardData({ data: wechat })
    }
  }
}
</script>

<style lang="scss">
@import '@/pages/photonest/styles.scss';
</style>
