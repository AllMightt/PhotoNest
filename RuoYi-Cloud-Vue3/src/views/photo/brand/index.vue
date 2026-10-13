<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true">
      <el-form-item label="摄影师" prop="photographerId">
        <el-select v-model="queryParams.photographerId" filterable clearable placeholder="请选择摄影师" style="width: 260px" @change="handleQuery">
          <el-option v-for="item in photographerOptions" :key="item.id" :label="item.brandName + ' / ' + item.shareCode" :value="item.id" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">查询</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-empty v-if="!queryParams.photographerId" description="请选择摄影师后查看品牌主页配置" />

    <el-card v-else shadow="never">
      <template #header>
        <div class="card-header">
          <span>品牌主页配置</span>
          <el-button type="primary" icon="Edit" @click="submitForm" v-hasPermi="['photo:brand:edit']">保存配置</el-button>
        </div>
      </template>
      <el-form ref="brandRef" :model="form" :rules="rules" label-width="130px">
        <el-row :gutter="20">
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
            <el-form-item label="Logo">
              <image-upload v-model="form.logoUrl" :limit="1" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="主页封面">
              <image-upload v-model="form.coverImage" :limit="1" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="副标题">
              <el-input v-model="form.subtitle" placeholder="请输入副标题" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="简介">
              <el-input v-model="form.intro" type="textarea" :rows="3" placeholder="请输入首页简介" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="关于页内容">
              <el-input v-model="form.aboutContent" type="textarea" :rows="6" placeholder="请输入关于页内容" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="城市">
              <el-input v-model="form.city" placeholder="请输入城市" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="联系电话">
              <el-input v-model="form.phone" placeholder="请输入联系电话" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="状态">
              <el-radio-group v-model="form.status">
                <el-radio v-for="item in normalStatusOptions" :key="item.value" :value="item.value">{{ item.label }}</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="微信号">
              <el-input v-model="form.wechatId" />
            </el-form-item>
          </el-col>
          <el-col :span="16">
            <el-form-item label="微信二维码">
              <image-upload v-model="form.wechatQr" :limit="1" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="小红书号">
              <el-input v-model="form.xiaohongshuId" />
            </el-form-item>
          </el-col>
          <el-col :span="16">
            <el-form-item label="小红书二维码">
              <image-upload v-model="form.xiaohongshuQr" :limit="1" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="抖音号">
              <el-input v-model="form.douyinId" />
            </el-form-item>
          </el-col>
          <el-col :span="16">
            <el-form-item label="抖音二维码">
              <image-upload v-model="form.douyinQr" :limit="1" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
    </el-card>
  </div>
</template>

<script setup name="PhotoBrand">
import { listPhotographer, getBrand, updateBrand } from '@/api/photo/admin'
import { normalStatusOptions } from '@/views/photo/common/options'

const { proxy } = getCurrentInstance()
const photographerOptions = ref([])

const data = reactive({
  queryParams: { photographerId: undefined },
  form: {},
  rules: {
    brandName: [{ required: true, message: '品牌名称不能为空', trigger: 'blur' }],
    photographerName: [{ required: true, message: '摄影师名称不能为空', trigger: 'blur' }]
  }
})
const { queryParams, form, rules } = toRefs(data)

function loadPhotographers() {
  listPhotographer({ pageNum: 1, pageSize: 1000 }).then(response => {
    photographerOptions.value = response.rows || []
  })
}

function handleQuery() {
  if (!queryParams.value.photographerId) return
  getBrand(queryParams.value.photographerId).then(response => {
    form.value = response.data || { photographerId: queryParams.value.photographerId, status: '0' }
    form.value.photographerId = queryParams.value.photographerId
  })
}

function resetQuery() {
  queryParams.value.photographerId = undefined
  form.value = {}
}

function submitForm() {
  proxy.$refs.brandRef.validate(valid => {
    if (!valid) return
    form.value.photographerId = queryParams.value.photographerId
    updateBrand(form.value).then(() => {
      proxy.$modal.msgSuccess('保存成功')
      handleQuery()
    })
  })
}

loadPhotographers()
</script>

<style scoped>
.card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}
</style>
