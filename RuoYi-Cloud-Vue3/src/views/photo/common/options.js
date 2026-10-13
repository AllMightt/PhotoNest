export const normalStatusOptions = [
  { label: '启用', value: '0', type: 'success' },
  { label: '停用', value: '1', type: 'danger' }
]

export const publishStatusOptions = [
  { label: '上架', value: '0', type: 'success' },
  { label: '下架', value: '1', type: 'info' },
  { label: '草稿', value: '2', type: 'warning' }
]

export const bookingStatusOptions = [
  { label: '待处理', value: '0', type: 'warning' },
  { label: '已联系', value: '1', type: 'primary' },
  { label: '已预约', value: '2', type: 'success' },
  { label: '已取消', value: '3', type: 'info' },
  { label: '无效线索', value: '4', type: 'danger' }
]

export const priceDisplayTypeOptions = [
  { label: '公开价格', value: 'public' },
  { label: '价格区间', value: 'range' },
  { label: '文案展示', value: 'text' },
  { label: '到店咨询', value: 'consult' },
  { label: '隐藏价格', value: 'hidden' }
]

export function optionLabel(options, value) {
  const item = options.find(option => option.value === value)
  return item ? item.label : value
}

export function optionType(options, value) {
  const item = options.find(option => option.value === value)
  return item ? item.type : ''
}

export function formatBytes(value) {
  const size = Number(value || 0)
  if (size >= 1024 * 1024 * 1024) return (size / 1024 / 1024 / 1024).toFixed(2) + ' GB'
  if (size >= 1024 * 1024) return (size / 1024 / 1024).toFixed(2) + ' MB'
  if (size >= 1024) return (size / 1024).toFixed(2) + ' KB'
  return size + ' B'
}
