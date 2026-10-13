<template>
  <view class="pn-page">
    <view class="pn-title">作品</view>
    <scroll-view scroll-x class="pn-tabs">
      <view
        v-for="category in categories"
        :key="category.id"
        class="pn-tab"
        :class="{ 'pn-tab-active': category.id === activeCategoryId }"
        @click="selectCategory(category.id)"
      >
        {{ category.categoryName }}
      </view>
    </scroll-view>

    <view class="pn-grid">
      <view v-for="work in works" :key="work.id" @click="goWork(work)">
        <image class="pn-cover" :src="work.coverUrl" mode="aspectFill" />
        <view class="pn-card-title">{{ work.title }}</view>
        <view class="pn-muted">#作品欣赏</view>
      </view>
      <view v-if="works.length % 2 === 1" class="pn-placeholder" />
    </view>

    <FloatingBooking />
  </view>
</template>

<script>
import FloatingBooking from '@/pages/photonest/components/FloatingBooking.vue'
import { getWorkCategories, getWorks } from '@/api/photonest/guest'
import { resolveShareCode, getStoredShareCode } from '@/utils/photonest/shareCode'
import { visibleCategories } from '@/utils/photonest/workCategories'

export default {
  components: { FloatingBooking },
  data() {
    return {
      shareCode: '',
      categories: [],
      activeCategoryId: undefined,
      works: [],
      pageNum: 1,
      total: 0
    }
  },
  onLoad(options) {
    this.shareCode = resolveShareCode(options) || getStoredShareCode()
    this.loadWorks(true).then(() => this.loadCategories())
  },
  onReachBottom() {
    if (this.works.length < this.total) {
      this.pageNum += 1
      this.loadWorks(false)
    }
  },
  methods: {
    loadCategories() {
      return getWorkCategories(this.shareCode).then(response => {
        this.categories = visibleCategories(response.data || response || [], this.works)
        this.activeCategoryId = this.categories[0] && this.categories[0].id
        if (this.activeCategoryId) {
          return this.loadWorks(true)
        }
      })
    },
    loadWorks(reset) {
      if (reset) {
        this.pageNum = 1
        this.works = []
      }
      return getWorks(this.shareCode, {
        pageNum: this.pageNum,
        pageSize: 10,
        categoryId: this.activeCategoryId
      }).then(response => {
        const rows = response.rows || (response.data && response.data.rows) || []
        this.works = reset ? rows : this.works.concat(rows)
        this.total = response.total || rows.length
      })
    },
    selectCategory(id) {
      this.activeCategoryId = id
      this.loadWorks(true)
    },
    goWork(work) {
      uni.navigateTo({ url: `/pages/photonest/guest/work-detail/index?shareCode=${this.shareCode}&id=${work.id}` })
    }
  }
}
</script>

<style lang="scss">
@import '@/pages/photonest/styles.scss';
</style>
