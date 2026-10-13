<template>
  <view class="page">
    <view v-if="submitted" class="section success-panel">
      <view class="title">提交成功</view>
      <view class="muted">预约咨询已提交，摄影师会尽快与你确认。</view>
      <view class="primary-button" style="margin-top:32rpx" @tap="confirmSuccess">确认</view>
    </view>

    <view v-else>
      <view class="title">预约咨询</view>
      <view class="section">
        <picker :range="shootTypes" :value="shootTypeIndex" @change="changeShootType">
          <view class="input picker-input">{{ form.shootType || '预约类型 *' }}</view>
        </picker>
        <picker mode="date" :value="form.expectedDate" @change="form.expectedDate = $event.detail.value">
          <view class="input picker-input">{{ form.expectedDate || '拍摄日期 *' }}</view>
        </picker>
        <picker mode="time" :value="selectedTime" @change="changeExpectedTime">
          <view class="input picker-input">{{ form.expectedTime || '预约时间段 *' }}</view>
        </picker>
        <view class="form-item"><input v-model="form.phone" class="input" placeholder="手机号 *" type="number" /></view>
        <view class="form-item"><input v-model="form.expectedLocation" class="input" placeholder="拍摄地点 *" /></view>
        <view class="form-item"><input v-model="form.wechatId" class="input" placeholder="微信号（选填，可修改）" /></view>
        <view class="form-item"><input v-model="form.customerName" class="input" placeholder="昵称/姓名 *" /></view>
        <view class="form-item"><textarea v-model="form.remark" class="textarea" placeholder="备注（选填）" /></view>
        <view class="primary-button" @tap="submit">提交预约</view>
      </view>
    </view>
  </view>
</template>

<script setup>
import { reactive, ref } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import { createBooking } from '../../../api/guest'
import { prepareGuestPage } from '../../../utils/authGuard'

const shareCode = ref('')
const submitted = ref(false)
const shootTypes = ['写真', '领证', '百天', '周岁', '婚礼', '订婚', '孕照', '亲子', '活动', '其他']
const shootTypeIndex = ref(-1)
const selectedTime = ref('')
const form = reactive({
  customerName: '',
  phone: '',
  wechatId: '',
  packageId: '',
  shootType: '',
  expectedDate: '',
  expectedTime: '',
  expectedLocation: '',
  remark: '',
  requirement: '',
  sourceChannel: 'miniapp',
  sourcePage: 'booking'
})

function changeShootType(event) {
  shootTypeIndex.value = Number(event.detail.value)
  form.shootType = shootTypes[shootTypeIndex.value] || ''
}

function changeExpectedTime(event) {
  selectedTime.value = event.detail.value
  form.expectedTime = event.detail.value
}

onLoad(async (options) => {
  shareCode.value = await prepareGuestPage(options)
  if (options.packageId) {
    form.packageId = options.packageId
    form.sourceType = 'package'
    form.sourcePackageId = options.packageId
  }
  if (options.workId) {
    form.sourceType = 'work'
    form.sourceWorkId = options.workId
  }
})

async function submit() {
  const required = ['shootType', 'expectedDate', 'expectedTime', 'phone', 'expectedLocation', 'customerName']
  if (required.some((key) => !form[key])) {
    uni.showToast({ title: '请填写必填信息', icon: 'none' })
    return
  }
  await createBooking(shareCode.value, {
    ...form,
    requirement: form.remark,
    sourceType: form.sourceType || 'page'
  })
  submitted.value = true
}

function confirmSuccess() {
  uni.switchTab({ url: '/pages/guest/home/index' })
}
</script>
