<template>
  <view class="page">
    <view class="title">作品</view>
    <scroll-view scroll-x class="category-scroll" show-scrollbar="false">
      <view class="category-row">
        <view
          v-for="category in categories"
          :key="category.id"
          class="category-tab"
          :class="{ active: category.id === activeCategoryId }"
          @tap="selectCategory(category.id)"
        >
          {{ category.categoryName }}
        </view>
      </view>
    </scroll-view>
    <view v-if="activeCategoryName" class="category-label">作品类型：{{ activeCategoryName }}</view>

    <view v-if="categories.length === 0" class="section muted">暂无作品分类</view>
    <view class="grid">
      <view v-for="work in works" :key="work.id" class="work-card" @tap="goWork(work)">
        <image class="work-cover" :src="work.coverUrl" mode="aspectFill" />
        <view class="work-title">{{ work.title }}</view>
        <view class="muted">#作品欣赏</view>
      </view>
      <view v-if="works.length % 2 === 1" class="placeholder-card" />
    </view>
    <view v-if="categories.length > 0 && works.length === 0" class="section muted">当前分类暂无作品</view>

    <FloatingBooking />
  </view>
</template>

<script setup>
import { computed, ref } from 'vue'
import { onLoad, onReachBottom, onPageScroll, onShow } from '@dcloudio/uni-app'
import FloatingBooking from '../../../components/FloatingBooking.vue'
import { getWorkCategories, getWorks } from '../../../api/guest'
import { prepareGuestPage } from '../../../utils/authGuard'
import { visibleCategories } from '../../../utils/workCategories'

const shareCode = ref('')
const categories = ref([])
const activeCategoryId = ref(undefined)
const works = ref([])
const pageNum = ref(1)
const total = ref(0)
const activeCategoryName = computed(() => categories.value.find((item) => item.id === activeCategoryId.value)?.categoryName || '')

onLoad(async (options) => {
  shareCode.value = await prepareGuestPage(options)
  await loadCategories()
})

onShow(() => {
  const shouldRestore = uni.getStorageSync('photonest.restoreWorksScroll')
  const y = uni.getStorageSync('photonest.worksScrollTop')
  if (shouldRestore && y) {
    uni.removeStorageSync('photonest.restoreWorksScroll')
    setTimeout(() => uni.pageScrollTo({ scrollTop: y, duration: 0 }), 0)
  }
})

onReachBottom(() => {
  if (works.value.length < total.value) {
    pageNum.value += 1
    loadWorks(false)
  }
})

onPageScroll(({ scrollTop }) => {
  uni.setStorageSync('photonest.worksScrollTop', scrollTop)
})

async function loadCategories() {
  const response = await getWorkCategories(shareCode.value)
  categories.value = visibleCategories(response.data || response || [], [])
  const cachedCategoryId = uni.getStorageSync('photonest.worksActiveCategoryId')
  activeCategoryId.value = categories.value.some((item) => item.id === cachedCategoryId)
    ? cachedCategoryId
    : categories.value[0]?.id
  if (activeCategoryId.value) {
    await loadWorks(true)
  }
}

async function loadWorks(reset) {
  if (reset) {
    pageNum.value = 1
    works.value = []
  }
  const response = await getWorks(shareCode.value, {
    pageNum: pageNum.value,
    pageSize: 10,
    categoryId: activeCategoryId.value
  })
  const rows = response.rows || response.data?.rows || []
  works.value = reset ? rows : works.value.concat(rows)
  total.value = response.total || rows.length
}

function selectCategory(id) {
  activeCategoryId.value = id
  uni.setStorageSync('photonest.worksActiveCategoryId', id)
  uni.removeStorageSync('photonest.worksScrollTop')
  loadWorks(true)
}

function goWork(work) {
  uni.setStorageSync('photonest.worksActiveCategoryId', activeCategoryId.value)
  uni.setStorageSync('photonest.restoreWorksScroll', '1')
  uni.navigateTo({ url: `/pages/guest/work-detail/index?shareCode=${shareCode.value}&id=${work.id}` })
}
</script>
