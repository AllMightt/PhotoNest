import request from './request'

export function getBrand() {
  return request({ url: '/photo/photographer/brand', method: 'get' })
}

export function updateBrand(data) {
  return request({ url: '/photo/photographer/brand', method: 'put', data })
}

export function listCategories(params) {
  return request({ url: '/photo/photographer/category/list', method: 'get', params })
}

export function saveCategory(data) {
  return request({ url: '/photo/photographer/category', method: data.id ? 'put' : 'post', data })
}

export function listWorks(params) {
  return request({ url: '/photo/photographer/work/list', method: 'get', params })
}

export function listPackages(params) {
  return request({ url: '/photo/photographer/package/list', method: 'get', params })
}

export function listBookings(params) {
  return request({ url: '/photo/photographer/booking/list', method: 'get', params })
}
