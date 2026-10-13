<template>
  <view class="pn-floating" @click="openBooking">预约</view>
</template>

<script>
import { getStoredShareCode } from '@/utils/photonest/shareCode'

export default {
  name: 'FloatingBooking',
  methods: {
    openBooking() {
      const shareCode = getStoredShareCode()
      uni.showActionSheet({
        itemList: ['填写预约表单', '添加客服'],
        success: ({ tapIndex }) => {
          if (tapIndex === 0) {
            uni.navigateTo({ url: `/pages/photonest/guest/booking/index?shareCode=${shareCode}` })
            return
          }
          uni.showToast({ title: '请在主页复制客服微信', icon: 'none' })
        }
      })
    }
  }
}
</script>

<style lang="scss">
@import '@/pages/photonest/styles.scss';
</style>
