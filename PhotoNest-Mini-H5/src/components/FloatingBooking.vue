<template>
  <movable-area class="floating-area">
    <movable-view
      class="floating-booking"
      direction="all"
      :x="position.x"
      :y="position.y"
      @change="savePosition"
      @tap="openBooking"
    >
      预约
    </movable-view>
  </movable-area>
</template>

<script setup>
import { reactive } from 'vue'
import { onMounted } from 'vue'
import { getStoredShareCode } from '../utils/shareCode'

const BUTTON_SIZE = 58
const position = reactive({ x: 0, y: 0 })

onMounted(() => {
  const shareCode = getStoredShareCode()
  const cached = uni.getStorageSync(`photonest.bookingButton.${shareCode}`)
  if (cached && typeof cached.x === 'number' && typeof cached.y === 'number') {
    position.x = cached.x
    position.y = cached.y
    return
  }
  const info = uni.getSystemInfoSync()
  position.x = Math.max(12, info.windowWidth - BUTTON_SIZE - 18)
  position.y = Math.max(80, info.windowHeight - BUTTON_SIZE - 132)
})

function openBooking() {
  const shareCode = getStoredShareCode()
  uni.navigateTo({ url: `/pages/guest/booking/index?shareCode=${shareCode}` })
}

function savePosition(event) {
  const shareCode = getStoredShareCode()
  uni.setStorageSync(`photonest.bookingButton.${shareCode}`, {
    x: event.detail.x,
    y: event.detail.y
  })
}
</script>
