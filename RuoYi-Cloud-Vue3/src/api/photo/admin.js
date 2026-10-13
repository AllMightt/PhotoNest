import request from '@/utils/request'

// 摄影师
export function listPhotographer(query) {
  return request({ url: '/photo/admin/photographer/list', method: 'get', params: query })
}

export function getPhotographer(id) {
  return request({ url: '/photo/admin/photographer/' + id, method: 'get' })
}

export function addPhotographer(data) {
  return request({ url: '/photo/admin/photographer', method: 'post', data })
}

export function updatePhotographer(data) {
  return request({ url: '/photo/admin/photographer', method: 'put', data })
}

export function updatePhotographerStatus(data) {
  return request({ url: '/photo/admin/photographer/status', method: 'put', data })
}

export function delPhotographer(ids) {
  return request({ url: '/photo/admin/photographer/' + ids, method: 'delete' })
}

// 品牌主页配置
export function getBrand(photographerId) {
  return request({ url: '/photo/admin/brand/' + photographerId, method: 'get' })
}

export function updateBrand(data) {
  return request({ url: '/photo/admin/brand', method: 'put', data })
}

// 作品分类
export function listCategory(query) {
  return request({ url: '/photo/admin/category/list', method: 'get', params: query })
}

export function getCategory(id) {
  return request({ url: '/photo/admin/category/' + id, method: 'get' })
}

export function addCategory(data) {
  return request({ url: '/photo/admin/category', method: 'post', data })
}

export function updateCategory(data) {
  return request({ url: '/photo/admin/category', method: 'put', data })
}

export function delCategory(ids) {
  return request({ url: '/photo/admin/category/' + ids, method: 'delete' })
}

// 作品
export function listWork(query) {
  return request({ url: '/photo/admin/work/list', method: 'get', params: query })
}

export function getWork(id) {
  return request({ url: '/photo/admin/work/' + id, method: 'get' })
}

export function addWork(data) {
  return request({ url: '/photo/admin/work', method: 'post', data })
}

export function updateWork(data) {
  return request({ url: '/photo/admin/work', method: 'put', data })
}

export function updateWorkStatus(data) {
  return request({ url: '/photo/admin/work/status', method: 'put', data })
}

export function delWork(ids) {
  return request({ url: '/photo/admin/work/' + ids, method: 'delete' })
}

// 作品图片
export function listWorkImage(query) {
  return request({ url: '/photo/admin/workImage/list', method: 'get', params: query })
}

export function getWorkImage(id) {
  return request({ url: '/photo/admin/workImage/' + id, method: 'get' })
}

export function addWorkImage(data) {
  return request({ url: '/photo/admin/workImage', method: 'post', data })
}

export function updateWorkImage(data) {
  return request({ url: '/photo/admin/workImage', method: 'put', data })
}

export function delWorkImage(ids) {
  return request({ url: '/photo/admin/workImage/' + ids, method: 'delete' })
}

// 套系
export function listPackage(query) {
  return request({ url: '/photo/admin/package/list', method: 'get', params: query })
}

export function getPackage(id) {
  return request({ url: '/photo/admin/package/' + id, method: 'get' })
}

export function addPackage(data) {
  return request({ url: '/photo/admin/package', method: 'post', data })
}

export function updatePackage(data) {
  return request({ url: '/photo/admin/package', method: 'put', data })
}

export function updatePackageStatus(data) {
  return request({ url: '/photo/admin/package/status', method: 'put', data })
}

export function delPackage(ids) {
  return request({ url: '/photo/admin/package/' + ids, method: 'delete' })
}

// 套系明细
export function listPackageItem(query) {
  return request({ url: '/photo/admin/packageItem/list', method: 'get', params: query })
}

export function getPackageItem(id) {
  return request({ url: '/photo/admin/packageItem/' + id, method: 'get' })
}

export function addPackageItem(data) {
  return request({ url: '/photo/admin/packageItem', method: 'post', data })
}

export function updatePackageItem(data) {
  return request({ url: '/photo/admin/packageItem', method: 'put', data })
}

export function delPackageItem(ids) {
  return request({ url: '/photo/admin/packageItem/' + ids, method: 'delete' })
}

// 预约咨询
export function listBooking(query) {
  return request({ url: '/photo/admin/booking/list', method: 'get', params: query })
}

export function getBooking(id) {
  return request({ url: '/photo/admin/booking/' + id, method: 'get' })
}

export function updateBookingStatus(data) {
  return request({ url: '/photo/admin/booking/status', method: 'put', data })
}
