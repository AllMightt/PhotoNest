<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch">
      <el-form-item label="摄影师" prop="photographerId">
        <el-select v-model="queryParams.photographerId" filterable clearable placeholder="请选择摄影师" style="width: 240px" @change="loadCategories">
          <el-option v-for="item in photographerOptions" :key="item.id" :label="item.brandName + ' / ' + item.shareCode" :value="item.id" />
        </el-select>
      </el-form-item>
      <el-form-item label="分类" prop="categoryId">
        <el-select v-model="queryParams.categoryId" filterable clearable placeholder="请选择分类" style="width: 180px">
          <el-option v-for="item in categoryOptions" :key="item.id" :label="item.categoryName" :value="item.id" />
        </el-select>
      </el-form-item>
      <el-form-item label="标题" prop="title">
        <el-input v-model="queryParams.title" placeholder="请输入作品标题" clearable style="width: 200px" @keyup.enter="handleQuery" />
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
        <el-button type="primary" plain icon="Plus" @click="handleAdd" v-hasPermi="['photo:work:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="Edit" :disabled="single" @click="handleUpdate" v-hasPermi="['photo:work:edit']">修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete" v-hasPermi="['photo:work:remove']">删除</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" />
    </el-row>

    <el-table v-loading="loading" :data="workList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="ID" prop="id" align="center" width="90" />
      <el-table-column label="封面" prop="coverUrl" align="center" width="90">
        <template #default="scope"><image-preview v-if="scope.row.coverUrl" :src="scope.row.coverUrl" :width="50" :height="50" /></template>
      </el-table-column>
      <el-table-column label="标题" prop="title" min-width="180" :show-overflow-tooltip="true" />
      <el-table-column label="摄影师ID" prop="photographerId" align="center" width="100" />
      <el-table-column label="分类ID" prop="categoryId" align="center" width="90" />
      <el-table-column label="拍摄类型" prop="shootType" align="center" width="120" />
      <el-table-column label="首页推荐" prop="isHomeRecommend" align="center" width="100">
        <template #default="scope"><el-tag :type="scope.row.isHomeRecommend === '1' ? 'success' : 'info'">{{ scope.row.isHomeRecommend === '1' ? '推荐' : '普通' }}</el-tag></template>
      </el-table-column>
      <el-table-column label="状态" prop="status" align="center" width="90">
        <template #default="scope"><el-tag :type="optionType(publishStatusOptions, scope.row.status)">{{ optionLabel(publishStatusOptions, scope.row.status) }}</el-tag></template>
      </el-table-column>
      <el-table-column label="发布时间" prop="publishTime" align="center" width="170">
        <template #default="scope">{{ parseTime(scope.row.publishTime) }}</template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="250" fixed="right" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="Picture" @click="handleImages(scope.row)" v-hasPermi="['photo:workImage:list']">图片</el-button>
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['photo:work:edit']">修改</el-button>
          <el-dropdown @command="status => handleStatus(scope.row, status)" v-hasPermi="['photo:work:status']">
            <el-button link type="primary">状态<el-icon class="el-icon--right"><arrow-down /></el-icon></el-button>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item v-for="item in publishStatusOptions" :key="item.value" :command="item.value">{{ item.label }}</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['photo:work:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" v-model="open" width="760px" append-to-body>
      <el-form ref="workRef" :model="form" :rules="rules" label-width="110px">
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="摄影师" prop="photographerId">
              <el-select v-model="form.photographerId" filterable placeholder="请选择摄影师" style="width: 100%" @change="loadFormCategories">
                <el-option v-for="item in photographerOptions" :key="item.id" :label="item.brandName + ' / ' + item.shareCode" :value="item.id" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="作品分类" prop="categoryId">
              <el-select v-model="form.categoryId" filterable clearable placeholder="请选择分类" style="width: 100%">
                <el-option v-for="item in formCategoryOptions" :key="item.id" :label="item.categoryName" :value="item.id" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="作品标题" prop="title">
              <el-input v-model="form.title" placeholder="请输入作品标题" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="封面">
              <image-upload v-model="form.coverUrl" :limit="1" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="拍摄类型">
              <el-input v-model="form.shootType" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="拍摄地点">
              <el-input v-model="form.shootLocation" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="拍摄时间">
              <el-date-picker v-model="form.shootTime" type="datetime" value-format="YYYY-MM-DD HH:mm:ss" placeholder="选择时间" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="标签">
              <el-input v-model="form.tags" placeholder="多个标签用逗号分隔" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="发布时间">
              <el-date-picker v-model="form.publishTime" type="datetime" value-format="YYYY-MM-DD HH:mm:ss" placeholder="选择时间" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="首页推荐">
              <el-radio-group v-model="form.isHomeRecommend">
                <el-radio value="1">是</el-radio>
                <el-radio value="0">否</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="排序">
              <el-input-number v-model="form.sort" :min="0" controls-position="right" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="状态">
              <el-select v-model="form.status" style="width: 100%">
                <el-option v-for="item in publishStatusOptions" :key="item.value" :label="item.label" :value="item.value" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="描述">
              <el-input v-model="form.description" type="textarea" :rows="4" placeholder="请输入作品描述" />
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

<script setup name="PhotoWork">
import { listPhotographer, listCategory, listWork, getWork, addWork, updateWork, updateWorkStatus, delWork } from '@/api/photo/admin'
import { publishStatusOptions, optionLabel, optionType } from '@/views/photo/common/options'

const { proxy } = getCurrentInstance()
const router = useRouter()
const photographerOptions = ref([])
const categoryOptions = ref([])
const formCategoryOptions = ref([])
const workList = ref([])
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
  queryParams: { pageNum: 1, pageSize: 10, photographerId: undefined, categoryId: undefined, title: undefined, status: undefined },
  rules: {
    photographerId: [{ required: true, message: '摄影师不能为空', trigger: 'change' }],
    title: [{ required: true, message: '作品标题不能为空', trigger: 'blur' }]
  }
})
const { queryParams, form, rules } = toRefs(data)

function loadPhotographers() { listPhotographer({ pageNum: 1, pageSize: 1000 }).then(res => { photographerOptions.value = res.rows || [] }) }
function loadCategories() {
  categoryOptions.value = []
  queryParams.value.categoryId = undefined
  if (!queryParams.value.photographerId) return
  listCategory({ pageNum: 1, pageSize: 1000, photographerId: queryParams.value.photographerId }).then(res => { categoryOptions.value = res.rows || [] })
}
function loadFormCategories() {
  formCategoryOptions.value = []
  form.value.categoryId = undefined
  if (!form.value.photographerId) return
  listCategory({ pageNum: 1, pageSize: 1000, photographerId: form.value.photographerId }).then(res => { formCategoryOptions.value = res.rows || [] })
}
function getList() {
  loading.value = true
  listWork(queryParams.value).then(res => { workList.value = res.rows; total.value = res.total; loading.value = false })
}
function reset() {
  form.value = { id: undefined, photographerId: queryParams.value.photographerId, categoryId: undefined, title: undefined, coverUrl: undefined, tags: undefined, shootType: undefined, shootLocation: undefined, shootTime: undefined, description: undefined, isHomeRecommend: '0', publishTime: undefined, sort: 0, status: '2', remark: undefined }
  formCategoryOptions.value = []
  if (form.value.photographerId) loadFormCategories()
  proxy.resetForm('workRef')
}
function cancel() { open.value = false; reset() }
function handleQuery() { queryParams.value.pageNum = 1; getList() }
function resetQuery() { proxy.resetForm('queryRef'); categoryOptions.value = []; handleQuery() }
function handleSelectionChange(selection) {
  ids.value = selection.map(item => item.id)
  single.value = selection.length !== 1
  multiple.value = !selection.length
}
function handleAdd() { reset(); open.value = true; title.value = '新增作品' }
function handleUpdate(row) {
  reset()
  const id = row.id || ids.value[0]
  getWork(id).then(res => {
    form.value = res.data || {}
    open.value = true
    title.value = '编辑作品'
    if (form.value.photographerId) {
      listCategory({ pageNum: 1, pageSize: 1000, photographerId: form.value.photographerId }).then(categoryRes => { formCategoryOptions.value = categoryRes.rows || [] })
    }
  })
}
function submitForm() {
  proxy.$refs.workRef.validate(valid => {
    if (!valid) return
    const request = form.value.id ? updateWork : addWork
    request(form.value).then(() => { proxy.$modal.msgSuccess(form.value.id ? '修改成功' : '新增成功'); open.value = false; getList() })
  })
}
function handleStatus(row, status) {
  updateWorkStatus({ id: row.id, status }).then(() => { proxy.$modal.msgSuccess('状态已更新'); getList() })
}
function handleDelete(row) {
  const deleteIds = row.id || ids.value
  proxy.$modal.confirm('是否确认删除作品编号为 "' + deleteIds + '" 的数据项？').then(() => delWork(deleteIds)).then(() => { getList(); proxy.$modal.msgSuccess('删除成功') })
}
function handleImages(row) {
  router.push({ path: '/photo/workImage', query: { photographerId: row.photographerId, workId: row.id } })
}

loadPhotographers()
getList()
</script>
