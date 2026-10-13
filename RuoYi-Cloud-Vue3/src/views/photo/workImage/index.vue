<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch">
      <el-form-item label="摄影师" prop="photographerId">
        <el-select v-model="queryParams.photographerId" filterable clearable placeholder="请选择摄影师" style="width: 240px" @change="loadWorks">
          <el-option v-for="item in photographerOptions" :key="item.id" :label="item.brandName + ' / ' + item.shareCode" :value="item.id" />
        </el-select>
      </el-form-item>
      <el-form-item label="作品" prop="workId">
        <el-select v-model="queryParams.workId" filterable clearable placeholder="请选择作品" style="width: 240px">
          <el-option v-for="item in workOptions" :key="item.id" :label="item.title" :value="item.id" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="Plus" @click="handleAdd" v-hasPermi="['photo:workImage:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="Edit" :disabled="single" @click="handleUpdate" v-hasPermi="['photo:workImage:edit']">修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete" v-hasPermi="['photo:workImage:remove']">删除</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" />
    </el-row>

    <el-table v-loading="loading" :data="imageList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="ID" prop="id" align="center" width="90" />
      <el-table-column label="缩略图" prop="thumbnailUrl" align="center" width="90">
        <template #default="scope"><image-preview v-if="scope.row.thumbnailUrl" :src="scope.row.thumbnailUrl" :width="50" :height="50" /></template>
      </el-table-column>
      <el-table-column label="作品ID" prop="workId" align="center" width="100" />
      <el-table-column label="原图" prop="originalUrl" min-width="220" :show-overflow-tooltip="true" />
      <el-table-column label="展示图" prop="displayUrl" min-width="220" :show-overflow-tooltip="true" />
      <el-table-column label="水印图" prop="watermarkUrl" min-width="220" :show-overflow-tooltip="true" />
      <el-table-column label="文件名" prop="fileName" min-width="120" :show-overflow-tooltip="true" />
      <el-table-column label="尺寸" align="center" width="120">
        <template #default="scope">{{ scope.row.width || 0 }} x {{ scope.row.height || 0 }}</template>
      </el-table-column>
      <el-table-column label="排序" prop="sort" align="center" width="80" />
      <el-table-column label="操作" align="center" width="150" fixed="right" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['photo:workImage:edit']">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['photo:workImage:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" v-model="open" width="760px" append-to-body>
      <el-form ref="imageRef" :model="form" :rules="rules" label-width="110px">
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="摄影师" prop="photographerId">
              <el-select v-model="form.photographerId" filterable placeholder="请选择摄影师" style="width: 100%" @change="loadFormWorks">
                <el-option v-for="item in photographerOptions" :key="item.id" :label="item.brandName + ' / ' + item.shareCode" :value="item.id" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="作品" prop="workId">
              <el-select v-model="form.workId" filterable placeholder="请选择作品" style="width: 100%">
                <el-option v-for="item in formWorkOptions" :key="item.id" :label="item.title" :value="item.id" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="上传展示图">
              <image-upload v-model="form.displayUrl" :limit="1" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="原图URL">
              <el-input v-model="form.originalUrl" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="展示图URL" prop="displayUrl">
              <el-input v-model="form.displayUrl" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="缩略图URL">
              <el-input v-model="form.thumbnailUrl" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="水印图URL">
              <el-input v-model="form.watermarkUrl" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="文件名">
              <el-input v-model="form.fileName" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="文件大小">
              <el-input-number v-model="form.fileSize" :min="0" controls-position="right" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="宽度">
              <el-input-number v-model="form.width" :min="0" controls-position="right" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="高度">
              <el-input-number v-model="form.height" :min="0" controls-position="right" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="排序">
              <el-input-number v-model="form.sort" :min="0" controls-position="right" />
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

<script setup name="PhotoWorkImage">
import { listPhotographer, listWork, listWorkImage, getWorkImage, addWorkImage, updateWorkImage, delWorkImage } from '@/api/photo/admin'

const { proxy } = getCurrentInstance()
const route = useRoute()
const photographerOptions = ref([])
const workOptions = ref([])
const formWorkOptions = ref([])
const imageList = ref([])
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
  queryParams: { pageNum: 1, pageSize: 10, photographerId: undefined, workId: undefined },
  rules: {
    photographerId: [{ required: true, message: '摄影师不能为空', trigger: 'change' }],
    workId: [{ required: true, message: '作品不能为空', trigger: 'change' }],
    displayUrl: [{ required: true, message: '展示图不能为空', trigger: 'blur' }]
  }
})
const { queryParams, form, rules } = toRefs(data)

function loadPhotographers() { listPhotographer({ pageNum: 1, pageSize: 1000 }).then(res => { photographerOptions.value = res.rows || [] }) }
function loadWorks() {
  workOptions.value = []
  queryParams.value.workId = undefined
  if (!queryParams.value.photographerId) return
  listWork({ pageNum: 1, pageSize: 1000, photographerId: queryParams.value.photographerId }).then(res => { workOptions.value = res.rows || [] })
}
function loadFormWorks() {
  formWorkOptions.value = []
  form.value.workId = undefined
  if (!form.value.photographerId) return
  listWork({ pageNum: 1, pageSize: 1000, photographerId: form.value.photographerId }).then(res => { formWorkOptions.value = res.rows || [] })
}
function getList() {
  loading.value = true
  listWorkImage(queryParams.value).then(res => { imageList.value = res.rows; total.value = res.total; loading.value = false })
}
function reset() {
  form.value = { id: undefined, photographerId: queryParams.value.photographerId, workId: queryParams.value.workId, originalUrl: undefined, displayUrl: undefined, thumbnailUrl: undefined, watermarkUrl: undefined, fileName: undefined, fileSize: 0, width: 0, height: 0, sort: 0, status: '0' }
  formWorkOptions.value = []
  if (form.value.photographerId) {
    listWork({ pageNum: 1, pageSize: 1000, photographerId: form.value.photographerId }).then(res => { formWorkOptions.value = res.rows || [] })
  }
  proxy.resetForm('imageRef')
}
function cancel() { open.value = false; reset() }
function handleQuery() { queryParams.value.pageNum = 1; getList() }
function resetQuery() { proxy.resetForm('queryRef'); workOptions.value = []; handleQuery() }
function handleSelectionChange(selection) {
  ids.value = selection.map(item => item.id)
  single.value = selection.length !== 1
  multiple.value = !selection.length
}
function handleAdd() { reset(); open.value = true; title.value = '新增作品图片' }
function handleUpdate(row) {
  reset()
  const id = row.id || ids.value[0]
  getWorkImage(id).then(res => {
    form.value = res.data || {}
    open.value = true
    title.value = '编辑作品图片'
    if (form.value.photographerId) {
      listWork({ pageNum: 1, pageSize: 1000, photographerId: form.value.photographerId }).then(workRes => { formWorkOptions.value = workRes.rows || [] })
    }
  })
}
function submitForm() {
  proxy.$refs.imageRef.validate(valid => {
    if (!valid) return
    if (!form.value.originalUrl) form.value.originalUrl = form.value.displayUrl
    if (!form.value.thumbnailUrl) form.value.thumbnailUrl = form.value.displayUrl
    if (!form.value.watermarkUrl) form.value.watermarkUrl = form.value.displayUrl
    const request = form.value.id ? updateWorkImage : addWorkImage
    request(form.value).then(() => { proxy.$modal.msgSuccess(form.value.id ? '修改成功' : '新增成功'); open.value = false; getList() })
  })
}
function handleDelete(row) {
  const deleteIds = row.id || ids.value
  proxy.$modal.confirm('是否确认删除作品图片编号为 "' + deleteIds + '" 的数据项？').then(() => delWorkImage(deleteIds)).then(() => { getList(); proxy.$modal.msgSuccess('删除成功') })
}

loadPhotographers()
if (route.query.photographerId) queryParams.value.photographerId = Number(route.query.photographerId)
if (route.query.workId) queryParams.value.workId = Number(route.query.workId)
if (queryParams.value.photographerId) {
  listWork({ pageNum: 1, pageSize: 1000, photographerId: queryParams.value.photographerId }).then(res => { workOptions.value = res.rows || [] })
}
getList()
</script>
