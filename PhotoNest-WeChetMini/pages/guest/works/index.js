const { getWorkCategories, getWorks } = require('../../../api/guest')
const { prepareGuestPage } = require('../../../utils/auth-guard')
const { visibleCategories } = require('../../../utils/work-categories')
const { normalizeImageFields } = require('../../../utils/file-url')

const CATEGORY_BATCH_SIZE = 12
const WORK_INITIAL_PAGE_SIZE = 12

Page({
  data: {
    shareCode: '',
    categories: [],
    displayCategories: [],
    categoryDisplayLimit: CATEGORY_BATCH_SIZE,
    hasMoreCategories: false,
    activeCategoryId: undefined,
    activeCategoryName: '',
    works: [],
    pageNum: 1,
    total: 0,
    hasMoreWorks: false,
    worksExpanded: false
  },

  async onLoad(options) {
    const shareCode = await prepareGuestPage(options)
    this.setData({ shareCode })
    await this.loadCategories()
  },

  onShow() {
    const resetFromHome = wx.getStorageSync('photonest.resetWorksFromHome')
    if (resetFromHome && this.data.categories.length) {
      wx.removeStorageSync('photonest.resetWorksFromHome')
      wx.removeStorageSync('photonest.worksActiveCategoryId')
      wx.removeStorageSync('photonest.worksScrollTop')
      wx.removeStorageSync('photonest.restoreWorksScroll')
      const activeCategoryId = this.data.categories[0] && this.data.categories[0].id
      const activeCategoryName = this.data.categories[0] ? this.data.categories[0].categoryName : ''
      this.setData({
        activeCategoryId,
        activeCategoryName,
        categoryDisplayLimit: CATEGORY_BATCH_SIZE
      })
      this.updateDisplayCategories()
      this.loadWorks(true)
      setTimeout(() => wx.pageScrollTo({ scrollTop: 0, duration: 0 }), 0)
      return
    }

    const shouldRestore = wx.getStorageSync('photonest.restoreWorksScroll')
    const y = wx.getStorageSync('photonest.worksScrollTop')
    if (shouldRestore && y) {
      wx.removeStorageSync('photonest.restoreWorksScroll')
      setTimeout(() => wx.pageScrollTo({ scrollTop: y, duration: 0 }), 0)
    }
  },

  onReachBottom() {},

  onPageScroll({ scrollTop }) {
    wx.setStorageSync('photonest.worksScrollTop', scrollTop)
  },

  async loadCategories() {
    const response = await getWorkCategories(this.data.shareCode)
    const categories = visibleCategories(response.data || response || [])
    const resetFromHome = wx.getStorageSync('photonest.resetWorksFromHome')
    const cachedCategoryId = resetFromHome ? '' : wx.getStorageSync('photonest.worksActiveCategoryId')
    const activeCategoryId = categories.some((item) => item.id === cachedCategoryId) ? cachedCategoryId : (categories[0] && categories[0].id)
    const activeCategory = categories.find((item) => item.id === activeCategoryId)
    const activeCategoryName = activeCategory ? activeCategory.categoryName : ''
    this.setData({
      categories,
      activeCategoryId,
      activeCategoryName,
      categoryDisplayLimit: CATEGORY_BATCH_SIZE
    })
    this.updateDisplayCategories()
    if (resetFromHome) {
      wx.removeStorageSync('photonest.resetWorksFromHome')
      setTimeout(() => wx.pageScrollTo({ scrollTop: 0, duration: 0 }), 0)
    }
    if (activeCategoryId) {
      await this.loadWorks(true)
    }
  },

  updateDisplayCategories() {
    const displayCategories = this.data.categories.slice(0, this.data.categoryDisplayLimit)
    this.setData({
      displayCategories,
      hasMoreCategories: displayCategories.length < this.data.categories.length
    })
  },

  showMoreCategories() {
    this.setData({
      categoryDisplayLimit: Math.min(this.data.categoryDisplayLimit + CATEGORY_BATCH_SIZE, this.data.categories.length)
    })
    this.updateDisplayCategories()
  },

  async loadWorks(reset, expandAll = false) {
    const pageSize = expandAll && this.data.total > WORK_INITIAL_PAGE_SIZE ? this.data.total : WORK_INITIAL_PAGE_SIZE
    const response = await getWorks(this.data.shareCode, {
      pageNum: 1,
      pageSize,
      categoryId: this.data.activeCategoryId
    })
    const rows = (response.rows || (response.data && response.data.rows) || []).map((item) => normalizeImageFields(item, ['coverUrl']))
    const total = response.total || rows.length
    this.setData({
      pageNum: 1,
      works: rows,
      total,
      worksExpanded: expandAll || rows.length >= total,
      hasMoreWorks: total > rows.length
    })
  },

  showMoreWorks() {
    if (!this.data.hasMoreWorks) return
    this.loadWorks(false, true)
  },

  selectCategory(event) {
    const id = event.currentTarget.dataset.id
    const activeCategory = this.data.categories.find((item) => item.id === id)
    const activeCategoryName = activeCategory ? activeCategory.categoryName : ''
    wx.setStorageSync('photonest.worksActiveCategoryId', id)
    wx.removeStorageSync('photonest.worksScrollTop')
    this.setData({ activeCategoryId: id, activeCategoryName })
    this.loadWorks(true)
  },

  goWork(event) {
    const id = event.currentTarget.dataset.id
    wx.setStorageSync('photonest.worksActiveCategoryId', this.data.activeCategoryId)
    wx.setStorageSync('photonest.restoreWorksScroll', '1')
    wx.navigateTo({ url: `/pages/guest/work-detail/index?shareCode=${this.data.shareCode}&id=${id}` })
  }
})
