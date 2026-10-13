<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch">
      <el-form-item label="品牌名称" prop="brandName">
        <el-input v-model="queryParams.brandName" placeholder="请输入品牌名称" clearable style="width: 200px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="摄影师" prop="photographerName">
        <el-input v-model="queryParams.photographerName" placeholder="请输入摄影师名称" clearable style="width: 200px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="shareCode" prop="shareCode">
        <el-input v-model="queryParams.shareCode" placeholder="请输入分享码" clearable style="width: 200px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="状态" clearable style="width: 160px">
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
        <el-button type="primary" plain icon="Plus" @click="handleAdd" v-hasPermi="['photo:photographer:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="Edit" :disabled="single" @click="handleUpdate" v-hasPermi="['photo:photographer:edit']">修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete" v-hasPermi="['photo:photographer:remove']">删除</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" />
    </el-row>

    <el-table v-loading="loading" :data="photographerList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="ID" prop="id" align="center" width="90" />
      <el-table-column label="品牌名称" prop="brandName" min-width="160" :show-overflow-tooltip="true" />
      <el-table-column label="摄影师" prop="photographerName" align="center" width="120" />
      <el-table-column label="shareCode" prop="shareCode" align="center" width="160">
        <template #default="scope">
          <el-tag>{{ scope.row.shareCode }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="城市" prop="city" align="center" width="100" />
      <el-table-column label="手机" prop="phone" align="center" width="130" />
      <el-table-column label="限制" align="center" min-width="220">
        <template #default="scope">
          <div class="limit-lines">
            <span>存储 {{ formatBytes(scope.row.storageUsed) }} / {{ formatBytes(scope.row.storageLimit) }}</span>
            <span>作品 {{ scope.row.workLimit || 0 }}，套系 {{ scope.row.packageLimit || 0 }}</span>
          </div>
        </template>
      </el-table-column>
      <el-table-column label="状态" prop="status" align="center" width="90">
        <template #default="scope">
          <el-switch
            v-model="scope.row.status"
            active-value="0"
            inactive-value="1"
            @change="handleStatusChange(scope.row)"
            v-hasPermi="['photo:photographer:status']"
          />
        </template>
      </el-table-column>
      <el-table-column label="创建时间" prop="createTime" align="center" width="170">
        <template #default="scope">{{ parseTime(scope.row.createTime) }}</template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="180" fixed="right" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['photo:photographer:edit']">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['photo:photographer:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" v-model="open" width="760px" append-to-body>
      <el-form ref="photographerRef" :model="form" :rules="rules" label-width="110px">
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="品牌名称" prop="brandName">
              <el-input v-model="form.brandName" placeholder="请输入品牌名称" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="摄影师名称" prop="photographerName">
              <el-input v-model="form.photographerName" placeholder="请输入摄影师名称" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="绑定用户ID" prop="userId">
              <el-input-number v-model="form.userId" :min="1" controls-position="right" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="shareCode" prop="shareCode">
              <el-input v-model="form.shareCode" placeholder="留空则后端自动生成" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="城市">
              <el-input v-model="form.city" placeholder="请输入城市" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="手机号">
              <el-input v-model="form.phone" placeholder="请输入手机号" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="微信号">
              <el-input v-model="form.wechatId" placeholder="请输入微信号" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="套餐类型">
              <el-input v-model="form.planType" placeholder="free / pro" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="存储限制">
              <el-input-number v-model="form.storageLimit" :min="0" controls-position="right" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="作品限制">
              <el-input-number v-model="form.workLimit" :min="0" controls-position="right" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="套系限制">
              <el-input-number v-model="form.packageLimit" :min="0" controls-position="right" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="头像">
              <image-upload v-model="form.avatar" :limit="1" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="封面">
              <image-upload v-model="form.coverImage" :limit="1" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="状态">
              <el-radio-group v-model="form.status">
                <el-radio v-for="item in normalStatusOptions" :key="item.value" :value="item.value">{{ item.label }}</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="备注">
              <el-input v-model="form.remark" type="textarea" placeholder="请输入备注" />
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

<script setup name="PhotoPhotographer">
import { listPhotographer, getPhotographer, addPhotographer, updatePhotographer, updatePhotographerStatus, delPhotographer } from '@/api/photo/admin'
import { normalStatusOptions, formatBytes } from '@/views/photo/common/options'

const { proxy } = getCurrentInstance()

const photographerList = ref([])
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
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    brandName: undefined,
    photographerName: undefined,
    shareCode: undefined,
    status: undefined
  },
  rules: {
    brandName: [{ required: true, message: '品牌名称不能为空', trigger: 'blur' }],
    photographerName: [{ required: true, message: '摄影师名称不能为空', trigger: 'blur' }]
  }
})

const { queryParams, form, rules } = toRefs(data)

function getList() {
  loading.value = true
  listPhotographer(queryParams.value).then(response => {
    photographerList.value = response.rows
    total.value = response.total
    loading.value = false
  })
}

function reset() {
  form.value = {
    id: undefined,
    userId: undefined,
    brandName: undefined,
    photographerName: undefined,
    shareCode: undefined,
    avatar: undefined,
    coverImage: undefined,
    city: undefined,
    phone: undefined,
    wechatId: undefined,
    status: '0',
    planType: 'free',
    storageLimit: 2147483648,
    storageUsed: 0,
    workLimit: 100,
    packageLimit: 20,
    remark: undefined
  }
  proxy.resetForm('photographerRef')
}

function cancel() {
  open.value = false
  reset()
}

function handleQuery() {
  queryParams.value.pageNum = 1
  getList()
}

function resetQuery() {
  proxy.resetForm('queryRef')
  handleQuery()
}

function handleSelectionChange(selection) {
  ids.value = selection.map(item => item.id)
  single.value = selection.length !== 1
  multiple.value = !selection.length
}

function handleAdd() {
  reset()
  open.value = true
  title.value = '新增摄影师'
}

function handleUpdate(row) {
  reset()
  const id = row.id || ids.value[0]
  getPhotographer(id).then(response => {
    form.value = response.data || {}
    open.value = true
    title.value = '编辑摄影师'
  })
}

function submitForm() {
  proxy.$refs.photographerRef.validate(valid => {
    if (!valid) return
    const request = form.value.id ? updatePhotographer : addPhotographer
    request(form.value).then(() => {
      proxy.$modal.msgSuccess(form.value.id ? '修改成功' : '新增成功')
      open.value = false
      getList()
    })
  })
}

function handleStatusChange(row) {
  const text = row.status === '0' ? '启用' : '禁用'
  proxy.$modal.confirm('确认要' + text + '摄影师 "' + row.brandName + '" 吗？').then(() => {
    return updatePhotographerStatus({ id: row.id, status: row.status })
  }).then(() => {
    proxy.$modal.msgSuccess(text + '成功')
  }).catch(() => {
    row.status = row.status === '0' ? '1' : '0'
  })
}

function handleDelete(row) {
  const deleteIds = row.id || ids.value
  proxy.$modal.confirm('是否确认删除摄影师编号为 "' + deleteIds + '" 的数据项？').then(() => {
    return delPhotographer(deleteIds)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess('删除成功')
  })
}

getList()
</script>

<style scoped>
.limit-lines {
  display: flex;
  flex-direction: column;
  gap: 4px;
  line-height: 1.4;
}
</style>
