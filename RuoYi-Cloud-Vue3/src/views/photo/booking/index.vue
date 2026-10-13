<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch">
      <el-form-item label="摄影师" prop="photographerId">
        <el-select v-model="queryParams.photographerId" filterable clearable placeholder="请选择摄影师" style="width: 240px">
          <el-option v-for="item in photographerOptions" :key="item.id" :label="item.brandName + ' / ' + item.shareCode" :value="item.id" />
        </el-select>
      </el-form-item>
      <el-form-item label="客户姓名" prop="customerName">
        <el-input v-model="queryParams.customerName" placeholder="请输入客户姓名" clearable style="width: 180px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="手机号" prop="phone">
        <el-input v-model="queryParams.phone" placeholder="请输入手机号" clearable style="width: 180px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" clearable placeholder="状态" style="width: 160px">
          <el-option v-for="item in bookingStatusOptions" :key="item.value" :label="item.label" :value="item.value" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" />
    </el-row>

    <el-table v-loading="loading" :data="bookingList">
      <el-table-column label="预约编号" prop="bookingNo" min-width="170" :show-overflow-tooltip="true" />
      <el-table-column label="摄影师ID" prop="photographerId" align="center" width="100" />
      <el-table-column label="客户姓名" prop="customerName" align="center" width="110" />
      <el-table-column label="手机号" prop="phone" align="center" width="130" />
      <el-table-column label="微信号" prop="wechatId" align="center" width="130" :show-overflow-tooltip="true" />
      <el-table-column label="拍摄类型" prop="shootType" align="center" width="110" />
      <el-table-column label="意向日期" prop="expectedDate" align="center" width="120" />
      <el-table-column label="意向时间段" prop="expectedTime" align="center" width="140" :show-overflow-tooltip="true" />
      <el-table-column label="地点" prop="expectedLocation" min-width="130" :show-overflow-tooltip="true" />
      <el-table-column label="来源" min-width="220" :show-overflow-tooltip="true">
        <template #default="scope">
          {{ scope.row.sourceChannel || '-' }} / {{ scope.row.sourcePage || '-' }} / {{ scope.row.sourceType || '-' }}
        </template>
      </el-table-column>
      <el-table-column label="来源作品" prop="sourceWorkId" align="center" width="100" />
      <el-table-column label="来源套系" prop="sourcePackageId" align="center" width="100" />
      <el-table-column label="状态" prop="status" align="center" width="100">
        <template #default="scope"><el-tag :type="optionType(bookingStatusOptions, scope.row.status)">{{ optionLabel(bookingStatusOptions, scope.row.status) }}</el-tag></template>
      </el-table-column>
      <el-table-column label="提交时间" prop="createTime" align="center" width="170">
        <template #default="scope">{{ parseTime(scope.row.createTime) }}</template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="170" fixed="right" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="View" @click="handleView(scope.row)" v-hasPermi="['photo:booking:query']">详情</el-button>
          <el-dropdown @command="status => handleStatus(scope.row, status)" v-hasPermi="['photo:booking:status']">
            <el-button link type="primary">状态<el-icon class="el-icon--right"><arrow-down /></el-icon></el-button>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item v-for="item in bookingStatusOptions" :key="item.value" :command="item.value">{{ item.label }}</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getList" />

    <el-dialog title="预约咨询详情" v-model="open" width="760px" append-to-body>
      <el-descriptions :column="2" border>
        <el-descriptions-item label="预约编号">{{ form.bookingNo }}</el-descriptions-item>
        <el-descriptions-item label="摄影师ID">{{ form.photographerId }}</el-descriptions-item>
        <el-descriptions-item label="客户姓名">{{ form.customerName }}</el-descriptions-item>
        <el-descriptions-item label="手机号">{{ form.phone }}</el-descriptions-item>
        <el-descriptions-item label="微信号">{{ form.wechatId }}</el-descriptions-item>
        <el-descriptions-item label="拍摄类型">{{ form.shootType }}</el-descriptions-item>
        <el-descriptions-item label="意向日期">{{ form.expectedDate }}</el-descriptions-item>
        <el-descriptions-item label="意向时间段">{{ form.expectedTime }}</el-descriptions-item>
        <el-descriptions-item label="意向地点">{{ form.expectedLocation }}</el-descriptions-item>
        <el-descriptions-item label="人数">{{ form.peopleCount }}</el-descriptions-item>
        <el-descriptions-item label="来源渠道">{{ form.sourceChannel }}</el-descriptions-item>
        <el-descriptions-item label="来源页面">{{ form.sourcePage }}</el-descriptions-item>
        <el-descriptions-item label="来源类型">{{ form.sourceType }}</el-descriptions-item>
        <el-descriptions-item label="来源作品">{{ form.sourceWorkId }}</el-descriptions-item>
        <el-descriptions-item label="来源套系">{{ form.sourcePackageId }}</el-descriptions-item>
        <el-descriptions-item label="状态">{{ optionLabel(bookingStatusOptions, form.status) }}</el-descriptions-item>
        <el-descriptions-item label="客户需求" :span="2">{{ form.requirement }}</el-descriptions-item>
        <el-descriptions-item label="备注" :span="2">{{ form.remark }}</el-descriptions-item>
      </el-descriptions>
    </el-dialog>
  </div>
</template>

<script setup name="PhotoBooking">
import { listPhotographer, listBooking, getBooking, updateBookingStatus } from '@/api/photo/admin'
import { bookingStatusOptions, optionLabel, optionType } from '@/views/photo/common/options'

const { proxy } = getCurrentInstance()
const photographerOptions = ref([])
const bookingList = ref([])
const loading = ref(true)
const showSearch = ref(true)
const total = ref(0)
const open = ref(false)

const data = reactive({
  queryParams: { pageNum: 1, pageSize: 10, photographerId: undefined, customerName: undefined, phone: undefined, status: undefined },
  form: {}
})
const { queryParams, form } = toRefs(data)

function loadPhotographers() { listPhotographer({ pageNum: 1, pageSize: 1000 }).then(res => { photographerOptions.value = res.rows || [] }) }
function getList() {
  loading.value = true
  listBooking(queryParams.value).then(res => { bookingList.value = res.rows; total.value = res.total; loading.value = false })
}
function handleQuery() { queryParams.value.pageNum = 1; getList() }
function resetQuery() { proxy.resetForm('queryRef'); handleQuery() }
function handleView(row) {
  getBooking(row.id).then(res => { form.value = res.data || {}; open.value = true })
}
function handleStatus(row, status) {
  updateBookingStatus({ id: row.id, status }).then(() => { proxy.$modal.msgSuccess('状态已更新'); getList() })
}

loadPhotographers()
getList()
</script>
