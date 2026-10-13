<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch">
      <el-form-item label="摄影师" prop="photographerId">
        <el-select v-model="queryParams.photographerId" filterable clearable placeholder="请选择摄影师" style="width: 240px">
          <el-option v-for="item in photographerOptions" :key="item.id" :label="item.brandName + ' / ' + item.shareCode" :value="item.id" />
        </el-select>
      </el-form-item>
      <el-form-item label="套系名称" prop="packageName">
        <el-input v-model="queryParams.packageName" placeholder="请输入套系名称" clearable style="width: 200px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" clearable placeholder="状态" style="width: 150px">
          <el-option v-for="item in publishStatusOptions" :key="item.value" :label="item.label" :value="item.value" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="Plus" @click="handleAdd" v-hasPermi="['photo:package:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="Edit" :disabled="single" @click="handleUpdate" v-hasPermi="['photo:package:edit']">修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete" v-hasPermi="['photo:package:remove']">删除</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" />
    </el-row>

    <el-table v-loading="loading" :data="packageList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="ID" prop="id" align="center" width="90" />
      <el-table-column label="封面" prop="coverUrl" align="center" width="90">
        <template #default="scope"><image-preview v-if="scope.row.coverUrl" :src="scope.row.coverUrl" :width="50" :height="50" /></template>
      </el-table-column>
      <el-table-column label="套系名称" prop="packageName" min-width="180" :show-overflow-tooltip="true" />
      <el-table-column label="摄影师ID" prop="photographerId" align="center" width="100" />
      <el-table-column label="价格展示" prop="priceDisplayType" align="center" width="110">
        <template #default="scope">{{ optionLabel(priceDisplayTypeOptions, scope.row.priceDisplayType) }}</template>
      </el-table-column>
      <el-table-column label="价格文案" prop="priceText" align="center" width="120" />
      <el-table-column label="价格" prop="price" align="center" width="100" />
      <el-table-column label="定金" prop="depositAmount" align="center" width="100" />
      <el-table-column label="时长/底片/精修" align="center" width="150">
        <template #default="scope">{{ scope.row.durationMinutes || 0 }}分 / {{ scope.row.originalPhotoCount || 0 }} / {{ scope.row.retouchPhotoCount || 0 }}</template>
      </el-table-column>
      <el-table-column label="状态" prop="status" align="center" width="90">
        <template #default="scope"><el-tag :type="optionType(publishStatusOptions, scope.row.status)">{{ optionLabel(publishStatusOptions, scope.row.status) }}</el-tag></template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="260" fixed="right" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="List" @click="handleItems(scope.row)" v-hasPermi="['photo:packageItem:list']">明细</el-button>
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['photo:package:edit']">修改</el-button>
          <el-dropdown @command="status => handleStatus(scope.row, status)" v-hasPermi="['photo:package:status']">
            <el-button link type="primary">状态<el-icon class="el-icon--right"><arrow-down /></el-icon></el-button>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item v-for="item in publishStatusOptions" :key="item.value" :command="item.value">{{ item.label }}</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['photo:package:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" v-model="open" width="820px" append-to-body>
      <el-form ref="packageRef" :model="form" :rules="rules" label-width="120px">
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="摄影师" prop="photographerId">
              <el-select v-model="form.photographerId" filterable placeholder="请选择摄影师" style="width: 100%">
                <el-option v-for="item in photographerOptions" :key="item.id" :label="item.brandName + ' / ' + item.shareCode" :value="item.id" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="套系名称" prop="packageName">
              <el-input v-model="form.packageName" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="封面">
              <image-upload v-model="form.coverUrl" :limit="1" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="价格展示方式">
              <el-select v-model="form.priceDisplayType" style="width: 100%">
                <el-option v-for="item in priceDisplayTypeOptions" :key="item.value" :label="item.label" :value="item.value" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="价格文案">
              <el-input v-model="form.priceText" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="状态">
              <el-select v-model="form.status" style="width: 100%">
                <el-option v-for="item in publishStatusOptions" :key="item.value" :label="item.label" :value="item.value" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="价格">
              <el-input-number v-model="form.price" :min="0" :precision="2" controls-position="right" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="定金">
              <el-input-number v-model="form.depositAmount" :min="0" :precision="2" controls-position="right" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="拍摄时长">
              <el-input-number v-model="form.durationMinutes" :min="0" controls-position="right" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="底片数量">
              <el-input-number v-model="form.originalPhotoCount" :min="0" controls-position="right" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="精修数量">
              <el-input-number v-model="form.retouchPhotoCount" :min="0" controls-position="right" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="排序">
              <el-input-number v-model="form.sort" :min="0" controls-position="right" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="适合人群">
              <el-input v-model="form.suitablePeople" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="交付周期">
              <el-input v-model="form.deliveryCycle" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="服务内容">
              <el-input v-model="form.serviceContent" type="textarea" :rows="4" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="预约须知">
              <el-input v-model="form.notice" type="textarea" :rows="3" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitForm">确 定</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="PhotoPackage">
import { listPhotographer, listPackage, getPackage, addPackage, updatePackage, updatePackageStatus, delPackage } from '@/api/photo/admin'
import { publishStatusOptions, priceDisplayTypeOptions, optionLabel, optionType } from '@/views/photo/common/options'

const { proxy } = getCurrentInstance()
const router = useRouter()
const photographerOptions = ref([])
const packageList = ref([])
const open = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)
const total = ref(0)
const title = ref('')

const data = reactive({
  form: {},
  queryParams: { pageNum: 1, pageSize: 10, photographerId: undefined, packageName: undefined, status: undefined },
  rules: {
    photographerId: [{ required: true, message: '摄影师不能为空', trigger: 'change' }],
    packageName: [{ required: true, message: '套系名称不能为空', trigger: 'blur' }]
  }
})
const { queryParams, form, rules } = toRefs(data)

function loadPhotographers() { listPhotographer({ pageNum: 1, pageSize: 1000 }).then(res => { photographerOptions.value = res.rows || [] }) }
function getList() {
  loading.value = true
  listPackage(queryParams.value).then(res => { packageList.value = res.rows; total.value = res.total; loading.value = false })
}
function reset() {
  form.value = { id: undefined, photographerId: queryParams.value.photographerId, packageName: undefined, coverUrl: undefined, priceDisplayType: 'public', priceText: undefined, price: undefined, depositAmount: undefined, durationMinutes: undefined, originalPhotoCount: undefined, retouchPhotoCount: undefined, suitablePeople: undefined, serviceContent: undefined, deliveryCycle: undefined, notice: undefined, sort: 0, status: '2' }
  proxy.resetForm('packageRef')
}
function cancel() { open.value = false; reset() }
function handleQuery() { queryParams.value.pageNum = 1; getList() }
function resetQuery() { proxy.resetForm('queryRef'); handleQuery() }
function handleSelectionChange(selection) {
  ids.value = selection.map(item => item.id)
  single.value = selection.length !== 1
  multiple.value = !selection.length
}
function handleAdd() { reset(); open.value = true; title.value = '新增套系' }
function handleUpdate(row) {
  reset()
  const id = row.id || ids.value[0]
  getPackage(id).then(res => { form.value = res.data || {}; open.value = true; title.value = '编辑套系' })
}
function submitForm() {
  proxy.$refs.packageRef.validate(valid => {
    if (!valid) return
    const request = form.value.id ? updatePackage : addPackage
    request(form.value).then(() => { proxy.$modal.msgSuccess(form.value.id ? '修改成功' : '新增成功'); open.value = false; getList() })
  })
}
function handleStatus(row, status) { updatePackageStatus({ id: row.id, status }).then(() => { proxy.$modal.msgSuccess('状态已更新'); getList() }) }
function handleDelete(row) {
  const deleteIds = row.id || ids.value
  proxy.$modal.confirm('是否确认删除套系编号为 "' + deleteIds + '" 的数据项？').then(() => delPackage(deleteIds)).then(() => { getList(); proxy.$modal.msgSuccess('删除成功') })
}
function handleItems(row) {
  router.push({ path: '/photo/packageItem', query: { photographerId: row.photographerId, packageId: row.id } })
}

loadPhotographers()
getList()
</script>
