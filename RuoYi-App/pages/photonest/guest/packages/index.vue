<template>
  <view class="pn-page">
    <view class="pn-title">套系</view>
    <view v-for="item in packages" :key="item.id" class="pn-section">
      <image v-if="item.coverUrl" class="pn-cover" :src="item.coverUrl" mode="aspectFill" />
      <view class="pn-card-title">{{ item.packageName }}</view>
      <view class="pn-muted">{{ item.priceText || item.price || '到店咨询' }}</view>
      <view class="pn-primary" style="margin-top:20rpx" @click="goBooking(item)">预约这个套系</view>
    </view>
    <FloatingBooking />
  </view>
</template>

<script>
import FloatingBooking from '@/pages/photonest/components/FloatingBooking.vue'
import { getPackages } from '@/api/photonest/guest'
import { resolveShareCode, getStoredShareCode } from '@/utils/photonest/shareCode'

export default {
  components: { FloatingBooking },
  data() {
    return {
      shareCode: '',
      packages: []
    }
  },
  onLoad(options) {
    this.shareCode = resolveShareCode(options) || getStoredShareCode()
    getPackages(this.shareCode, { pageNum: 1, pageSize: 20 }).then(response => {
      this.packages = response.rows || (response.data && response.data.rows) || []
    })
  },
  methods: {
    goBooking(item) {
      uni.navigateTo({ url: `/pages/photonest/guest/booking/index?shareCode=${this.shareCode}&packageId=${item.id}` })
    }
  }
}
</script>

<style lang="scss">
@import '@/pages/photonest/styles.scss';
</style>
