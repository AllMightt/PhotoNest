<template>
  <view class="pn-page">
    <view class="pn-section">
      <view class="pn-title">{{ work.title }}</view>
      <view class="pn-muted">{{ work.description || work.shootLocation }}</view>
    </view>
    <image
      v-for="image in images"
      :key="image.id"
      class="pn-hero-image"
      style="margin-bottom:22rpx;height:auto"
      :src="image.displayUrl || image.originalUrl"
      mode="widthFix"
    />
    <FloatingBooking />
  </view>
</template>

<script>
import FloatingBooking from '@/pages/photonest/components/FloatingBooking.vue'
import { getWorkDetail } from '@/api/photonest/guest'
import { resolveShareCode } from '@/utils/photonest/shareCode'

export default {
  components: { FloatingBooking },
  data() {
    return {
      shareCode: '',
      work: {},
      images: []
    }
  },
  onLoad(options) {
    this.shareCode = resolveShareCode(options)
    getWorkDetail(this.shareCode, options.id).then(response => {
      const data = response.data || response
      this.work = data.work || {}
      this.images = data.images || []
    })
  }
}
</script>

<style lang="scss">
@import '@/pages/photonest/styles.scss';
</style>
