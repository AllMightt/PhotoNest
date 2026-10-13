<template>
  <div class="app-shell">
    <aside class="sidebar">
      <div class="brand">PhotoNest 摄影师</div>
      <nav class="nav">
        <button
          v-for="item in navItems"
          :key="item.key"
          class="nav-button"
          :class="{ active: activeTab === item.key }"
          @click="activeTab = item.key"
        >
          {{ item.label }}
        </button>
      </nav>
    </aside>

    <main class="main">
      <div class="topbar">
        <div>
          <h1 class="title">{{ currentTitle }}</h1>
          <div class="muted">独立摄影师工作台，单独部署，不影响管理员后台。</div>
        </div>
        <button class="button ghost" @click="refresh">刷新</button>
      </div>

      <section class="stats">
        <div class="stat"><span class="muted">作品</span><strong>{{ works.length }}</strong></div>
        <div class="stat"><span class="muted">分类</span><strong>{{ categories.length }}</strong></div>
        <div class="stat"><span class="muted">套系</span><strong>{{ packages.length }}</strong></div>
        <div class="stat"><span class="muted">预约</span><strong>{{ bookings.length }}</strong></div>
      </section>

      <section v-if="activeTab === 'brand'" class="workspace">
        <div class="panel">
          <h2>品牌主页</h2>
          <div class="form-grid">
            <div class="field">
              <label>品牌名称</label>
              <input v-model="brandForm.brandName" placeholder="例如 树下摄影" />
            </div>
            <div class="field">
              <label>摄影师名称</label>
              <input v-model="brandForm.photographerName" placeholder="摄影师姓名" />
            </div>
            <div class="field">
              <label>城市</label>
              <input v-model="brandForm.city" placeholder="服务城市" />
            </div>
            <div class="field">
              <label>微信</label>
              <input v-model="brandForm.wechatId" placeholder="客服微信号" />
            </div>
            <div class="field" style="grid-column:1/-1">
              <label>关于我们</label>
              <textarea v-model="brandForm.aboutContent" placeholder="展示给客人的品牌介绍" />
            </div>
          </div>
          <button class="button" style="margin-top:16px" @click="saveBrand">保存品牌配置</button>
        </div>

        <div class="panel">
          <h2>分享入口</h2>
          <p class="muted">摄影师分享小程序或 H5 时携带自己的 shareCode，客人只能看到当前摄影师内容。</p>
          <div class="field">
            <label>H5 分享链接</label>
            <input :value="shareUrl" readonly />
          </div>
        </div>
      </section>

      <section v-else-if="activeTab === 'categories'" class="workspace">
        <div class="panel">
          <h2>分类顺序</h2>
          <p class="muted">每个摄影师有自己的分类顺序。调整后，客人端作品 Tab 按这里的顺序展示；无作品分类会在客人端隐藏。</p>
          <div class="list">
            <div v-for="category in categoryRows" :key="category.id" class="list-row">
              <div>
                <strong>{{ category.categoryName }}</strong>
                <div class="muted">{{ category.workCount }} 个作品，排序 {{ category.sort }}</div>
              </div>
              <div style="display:flex;gap:8px">
                <button class="button ghost" @click="moveCategory(category, -1)">上移</button>
                <button class="button ghost" @click="moveCategory(category, 1)">下移</button>
              </div>
            </div>
          </div>
        </div>

        <div class="panel">
          <h2>新增分类</h2>
          <div class="field">
            <label>分类名称</label>
            <input v-model="newCategoryName" placeholder="写真、领证、婚礼、百天" />
          </div>
          <button class="button" style="margin-top:16px" @click="addCategory">新增分类</button>
        </div>
      </section>

      <section v-else-if="activeTab === 'works'" class="panel">
        <h2>作品管理</h2>
        <div class="table-card">
          <div class="table-row muted">
            <span>作品</span><span>分类</span><span>发布时间</span><span>状态</span>
          </div>
          <div v-for="work in works" :key="work.id" class="table-row">
            <span>{{ work.title }}</span>
            <span>{{ categoryName(work.categoryId) }}</span>
            <span>{{ work.publishTime || '-' }}</span>
            <span>{{ work.status === '0' ? '已上架' : '未上架' }}</span>
          </div>
        </div>
      </section>

      <section v-else-if="activeTab === 'packages'" class="panel">
        <h2>套系管理</h2>
        <div class="table-card">
          <div class="table-row muted">
            <span>套系</span><span>价格</span><span>适合人群</span><span>状态</span>
          </div>
          <div v-for="item in packages" :key="item.id" class="table-row">
            <span>{{ item.packageName }}</span>
            <span>{{ item.priceText || item.price || '-' }}</span>
            <span>{{ item.suitablePeople || '-' }}</span>
            <span>{{ item.status === '0' ? '已上架' : '未上架' }}</span>
          </div>
        </div>
      </section>

      <section v-else class="panel">
        <h2>预约管理</h2>
        <div class="table-card">
          <div class="table-row muted">
            <span>客人</span><span>手机号</span><span>微信</span><span>状态</span>
          </div>
          <div v-for="booking in bookings" :key="booking.id" class="table-row">
            <span>{{ booking.customerName }}</span>
            <span>{{ maskPhone(booking.phone) }}</span>
            <span>{{ booking.wechatId || '-' }}</span>
            <span>{{ bookingStatus(booking.status) }}</span>
          </div>
        </div>
      </section>
    </main>
  </div>
</template>

<script setup>
import { computed, reactive, ref } from 'vue'
import { getBrand, listBookings, listCategories, listPackages, listWorks, saveCategory, updateBrand } from './api/workbench'
import { categoriesWithWorkCount, reorderCategories } from './utils/categoryOrder'
import { maskPhone } from './utils/phone'

const navItems = [
  { key: 'brand', label: '品牌主页' },
  { key: 'categories', label: '作品分类' },
  { key: 'works', label: '作品管理' },
  { key: 'packages', label: '套系管理' },
  { key: 'bookings', label: '预约管理' }
]

const activeTab = ref('brand')
const brandForm = reactive({})
const categories = ref([])
const works = ref([])
const packages = ref([])
const bookings = ref([])
const newCategoryName = ref('')

const currentTitle = computed(() => navItems.find((item) => item.key === activeTab.value)?.label)
const categoryRows = computed(() => categoriesWithWorkCount(categories.value, works.value))
const shareUrl = computed(() => {
  const shareCode = brandForm.shareCode || 'YOUR_SHARE_CODE'
  return `${window.location.origin}/pages/guest/home/index?shareCode=${shareCode}`
})

refresh()

async function refresh() {
  await Promise.allSettled([loadBrand(), loadCategories(), loadWorks(), loadPackages(), loadBookings()])
}

async function loadBrand() {
  const response = await getBrand()
  Object.assign(brandForm, response.data || response || {})
}

async function loadCategories() {
  const response = await listCategories({ pageNum: 1, pageSize: 100 })
  categories.value = response.rows || response.data?.rows || []
}

async function loadWorks() {
  const response = await listWorks({ pageNum: 1, pageSize: 100 })
  works.value = response.rows || response.data?.rows || []
}

async function loadPackages() {
  const response = await listPackages({ pageNum: 1, pageSize: 100 })
  packages.value = response.rows || response.data?.rows || []
}

async function loadBookings() {
  const response = await listBookings({ pageNum: 1, pageSize: 100 })
  bookings.value = response.rows || response.data?.rows || []
}

async function saveBrand() {
  await updateBrand({ ...brandForm })
  window.alert('品牌配置已保存')
}

function categoryName(id) {
  return categories.value.find((item) => Number(item.id) === Number(id))?.categoryName || '-'
}

async function addCategory() {
  if (!newCategoryName.value.trim()) {
    return
  }
  await saveCategory({
    categoryName: newCategoryName.value.trim(),
    sort: (categories.value.length + 1) * 10,
    status: '0'
  })
  newCategoryName.value = ''
  await loadCategories()
}

async function moveCategory(category, direction) {
  const rows = categoryRows.value
  const index = rows.findIndex((item) => item.id === category.id)
  const target = rows[index + direction]
  if (!target) {
    return
  }
  const next = reorderCategories(rows, category.id, target.id)
  categories.value = next
  await Promise.all(next.map((item) => saveCategory(item)))
}

function bookingStatus(status) {
  return ({ 0: '待跟进', 1: '已联系', 2: '已完成', 3: '已取消' })[status] || '待跟进'
}
</script>
