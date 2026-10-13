<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch">
      <el-form-item label="摄影师" prop="photographerId">
        <el-select v-model="queryParams.photographerId" filterable clearable placeholder="请选择摄影师" style="width: 240px" @change="loadPackages">
          <el-option v-for="item in photographerOptions" :key="item.id" :label="item.brandName + ' / ' + item.shareCode" :value="item.id" />
        </el-select>
      </el-form-item>
      <el-form-item label="套系" prop="packageId">
        <el-select v-model="queryParams.packageId" filterable clearable placeholder="请选择套系" style="width: 240px">
          <el-option v-for="item in packageOptions" :key="item.id" :label="item.packageName" :value="item.id" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="Plus" @click="handleAdd" v-hasPermi="['photo:packageItem:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="Edit" :disabled="single" @click="handleUpdate" v-hasPermi="['photo:packageItem:edit']">修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete" v-hasPermi="['photo:packageItem:remove']">删除</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" />
    </el-row>

    <el-table v-loading="loading" :data="itemList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="ID" prop="id" align="center" width="90" />
      <el-table-column label="套系ID" prop="packageId" align="center" width="100" />
      <el-table-column label="明细项" prop="itemName" min-width="160" />
      <el-table-column label="内容" prop="itemValue" min-width="220" :show-overflow-tooltip="true" />
      <el-table-column label="排序" prop="sort" align="center" width="90" />
      <el-table-column label="操作" align="center" width="150" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['photo:packageItem:edit']">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['photo:packageItem:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" v-model="open" width="620px" append-to-body>
      <el-form ref="itemRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="摄影师" prop="photographerId">
          <el-select v-model="form.photographerId" filterable placeholder="请选择摄影师" style="width: 100%" @change="loadFormPackages">
            <el-option v-for="item in photographerOptions" :key="item.id" :label="item.brandName + ' / ' + item.shareCode" :value="item.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="套系" prop="packageId">
          <el-select v-model="form.packageId" filterable placeholder="请选择套系" style="width: 100%">
            <el-option v-for="item in formPackageOptions" :key="item.id" :label="item.packageName" :value="item.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="明细项" prop="itemName">
          <el-input v-model="form.itemName" placeholder="如：拍摄时长、精修张数" />
        </el-form-item>
        <el-form-item label="明细内容" prop="itemValue">
          <el-input v-model="form.itemValue" placeholder="请输入明细内容" />
        </el-form-item>
        <el-form-item label="排序" prop="sort">
          <el-input-number v-model="form.sort" :min="0" controls-position="right" />
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="form.remark" type="textarea" />
        </el-form-item>
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

<script setup name="PhotoPackageItem">
import { listPhotographer, listPackage, listPackageItem, getPackageItem, addPackageItem, updatePackageItem, delPackageItem } from '@/api/photo/admin'

const { proxy } = getCurrentInstance()
const route = useRoute()
const photographerOptions = ref([])
const packageOptions = ref([])
const formPackageOptions = ref([])
const itemList = ref([])
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
  queryParams: { pageNum: 1, pageSize: 10, photographerId: undefined, packageId: undefined },
  rules: {
    photographerId: [{ required: true, message: '摄影师不能为空', trigger: 'change' }],
    packageId: [{ required: true, message: '套系不能为空', trigger: 'change' }],
    itemName: [{ required: true, message: '明细项不能为空', trigger: 'blur' }],
    itemValue: [{ required: true, message: '明细内容不能为空', trigger: 'blur' }]
  }
})
const { queryParams, form, rules } = toRefs(data)

function loadPhotographers() { listPhotographer({ pageNum: 1, pageSize: 1000 }).then(res => { photographerOptions.value = res.rows || [] }) }
function loadPackages() {
  packageOptions.value = []
  queryParams.value.packageId = undefined
  if (!queryParams.value.photographerId) return
  listPackage({ pageNum: 1, pageSize: 1000, photographerId: queryParams.value.photographerId }).then(res => { packageOptions.value = res.rows || [] })
}
function loadFormPackages() {
  formPackageOptions.value = []
  form.value.packageId = undefined
  if (!form.value.photographerId) return
  listPackage({ pageNum: 1, pageSize: 1000, photographerId: form.value.photographerId }).then(res => { formPackageOptions.value = res.rows || [] })
}
function getList() {
  loading.value = true
  listPackageItem(queryParams.value).then(res => { itemList.value = res.rows; total.value = res.total; loading.value = false })
}
function reset() {
  form.value = { id: undefined, photographerId: queryParams.value.photographerId, packageId: queryParams.value.packageId, itemName: undefined, itemValue: undefined, sort: 0, remark: undefined }
  formPackageOptions.value = []
  if (form.value.photographerId) {
    listPackage({ pageNum: 1, pageSize: 1000, photographerId: form.value.photographerId }).then(res => { formPackageOptions.value = res.rows || [] })
  }
  proxy.resetForm('itemRef')
}
function cancel() { open.value = false; reset() }
function handleQuery() { queryParams.value.pageNum = 1; getList() }
function resetQuery() { proxy.resetForm('queryRef'); packageOptions.value = []; handleQuery() }
function handleSelectionChange(selection) {
  ids.value = selection.map(item => item.id)
  single.value = selection.length !== 1
  multiple.value = !selection.length
}
function handleAdd() { reset(); open.value = true; title.value = '新增套系明细' }
function handleUpdate(row) {
  reset()
  const id = row.id || ids.value[0]
  getPackageItem(id).then(res => {
    form.value = res.data || {}
    open.value = true
    title.value = '编辑套系明细'
    if (form.value.photographerId) {
      listPackage({ pageNum: 1, pageSize: 1000, photographerId: form.value.photographerId }).then(packageRes => { formPackageOptions.value = packageRes.rows || [] })
    }
  })
}
function submitForm() {
  proxy.$refs.itemRef.validate(valid => {
    if (!valid) return
    const request = form.value.id ? updatePackageItem : addPackageItem
    request(form.value).then(() => { proxy.$modal.msgSuccess(form.value.id ? '修改成功' : '新增成功'); open.value = false; getList() })
  })
}
function handleDelete(row) {
  const deleteIds = row.id || ids.value
  proxy.$modal.confirm('是否确认删除套系明细编号为 "' + deleteIds + '" 的数据项？').then(() => delPackageItem(deleteIds)).then(() => { getList(); proxy.$modal.msgSuccess('删除成功') })
}

loadPhotographers()
if (route.query.photographerId) queryParams.value.photographerId = Number(route.query.photographerId)
if (route.query.packageId) queryParams.value.packageId = Number(route.query.packageId)
if (queryParams.value.photographerId) {
  listPackage({ pageNum: 1, pageSize: 1000, photographerId: queryParams.value.photographerId }).then(res => { packageOptions.value = res.rows || [] })
}
getList()
</script>
