<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch">
      <el-form-item label="摄影师" prop="photographerId">
        <el-select v-model="queryParams.photographerId" filterable clearable placeholder="请选择摄影师" style="width: 240px">
          <el-option v-for="item in photographerOptions" :key="item.id" :label="item.brandName + ' / ' + item.shareCode" :value="item.id" />
        </el-select>
      </el-form-item>
      <el-form-item label="分类名称" prop="categoryName">
        <el-input v-model="queryParams.categoryName" placeholder="请输入分类名称" clearable style="width: 200px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" clearable placeholder="状态" style="width: 160px">
          <el-option v-for="item in normalStatusOptions" :key="item.value" :label="item.label" :value="item.value" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="Plus" @click="handleAdd" v-hasPermi="['photo:category:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="Edit" :disabled="single" @click="handleUpdate" v-hasPermi="['photo:category:edit']">修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete" v-hasPermi="['photo:category:remove']">删除</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" />
    </el-row>

    <el-table v-loading="loading" :data="categoryList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="ID" prop="id" align="center" width="90" />
      <el-table-column label="摄影师ID" prop="photographerId" align="center" width="100" />
      <el-table-column label="分类名称" prop="categoryName" min-width="160" />
      <el-table-column label="图标" prop="categoryIcon" align="center" width="90">
        <template #default="scope">
          <image-preview v-if="scope.row.categoryIcon" :src="scope.row.categoryIcon" :width="40" :height="40" />
        </template>
      </el-table-column>
      <el-table-column label="排序" prop="sort" align="center" width="90" />
      <el-table-column label="状态" prop="status" align="center" width="100">
        <template #default="scope">
          <el-tag :type="optionType(normalStatusOptions, scope.row.status)">{{ optionLabel(normalStatusOptions, scope.row.status) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="创建时间" prop="createTime" align="center" width="170">
        <template #default="scope">{{ parseTime(scope.row.createTime) }}</template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="170" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['photo:category:edit']">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['photo:category:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" v-model="open" width="620px" append-to-body>
      <el-form ref="categoryRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="摄影师" prop="photographerId">
          <el-select v-model="form.photographerId" filterable placeholder="请选择摄影师" style="width: 100%">
            <el-option v-for="item in photographerOptions" :key="item.id" :label="item.brandName + ' / ' + item.shareCode" :value="item.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="分类名称" prop="categoryName">
          <el-input v-model="form.categoryName" placeholder="请输入分类名称" />
        </el-form-item>
        <el-form-item label="分类图标">
          <image-upload v-model="form.categoryIcon" :limit="1" />
        </el-form-item>
        <el-form-item label="排序" prop="sort">
          <el-input-number v-model="form.sort" :min="0" controls-position="right" />
        </el-form-item>
        <el-form-item label="状态">
          <el-radio-group v-model="form.status">
            <el-radio v-for="item in normalStatusOptions" :key="item.value" :value="item.value">{{ item.label }}</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="form.remark" type="textarea" placeholder="请输入备注" />
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

<script setup name="PhotoCategory">
import { listPhotographer, listCategory, getCategory, addCategory, updateCategory, delCategory } from '@/api/photo/admin'
import { normalStatusOptions, optionLabel, optionType } from '@/views/photo/common/options'

const { proxy } = getCurrentInstance()
const photographerOptions = ref([])
const categoryList = ref([])
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
  queryParams: { pageNum: 1, pageSize: 10, photographerId: undefined, categoryName: undefined, status: undefined },
  rules: {
    photographerId: [{ required: true, message: '摄影师不能为空', trigger: 'change' }],
    categoryName: [{ required: true, message: '分类名称不能为空', trigger: 'blur' }],
    sort: [{ required: true, message: '排序不能为空', trigger: 'blur' }]
  }
})
const { queryParams, form, rules } = toRefs(data)

function loadPhotographers() {
  listPhotographer({ pageNum: 1, pageSize: 1000 }).then(response => { photographerOptions.value = response.rows || [] })
}
function getList() {
  loading.value = true
  listCategory(queryParams.value).then(response => {
    categoryList.value = response.rows
    total.value = response.total
    loading.value = false
  })
}
function reset() {
  form.value = { id: undefined, photographerId: queryParams.value.photographerId, categoryName: undefined, categoryIcon: undefined, sort: 0, status: '0', remark: undefined }
  proxy.resetForm('categoryRef')
}
function cancel() { open.value = false; reset() }
function handleQuery() { queryParams.value.pageNum = 1; getList() }
function resetQuery() { proxy.resetForm('queryRef'); handleQuery() }
function handleSelectionChange(selection) {
  ids.value = selection.map(item => item.id)
  single.value = selection.length !== 1
  multiple.value = !selection.length
}
function handleAdd() { reset(); open.value = true; title.value = '新增作品分类' }
function handleUpdate(row) {
  reset()
  const id = row.id || ids.value[0]
  getCategory(id).then(response => { form.value = response.data || {}; open.value = true; title.value = '编辑作品分类' })
}
function submitForm() {
  proxy.$refs.categoryRef.validate(valid => {
    if (!valid) return
    const request = form.value.id ? updateCategory : addCategory
    request(form.value).then(() => { proxy.$modal.msgSuccess(form.value.id ? '修改成功' : '新增成功'); open.value = false; getList() })
  })
}
function handleDelete(row) {
  const deleteIds = row.id || ids.value
  proxy.$modal.confirm('是否确认删除分类编号为 "' + deleteIds + '" 的数据项？').then(() => delCategory(deleteIds)).then(() => {
    getList()
    proxy.$modal.msgSuccess('删除成功')
  })
}

loadPhotographers()
getList()
</script>
