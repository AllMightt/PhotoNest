import { request } from './request'

export function getHome(shareCode) {
  return request({ url: `/photo/app/home/${shareCode}` })
}

export function getAbout(shareCode) {
  return request({ url: `/photo/app/about/${shareCode}` })
}

export function getWorkCategories(shareCode) {
  return request({ url: `/photo/app/work/category/${shareCode}` })
}

export function getWorks(shareCode, params) {
  return request({ url: `/photo/app/work/list/${shareCode}`, params })
}

export function getWorkDetail(shareCode, id) {
  return request({ url: `/photo/app/work/${shareCode}/${id}` })
}

export function getPackages(shareCode, params) {
  return request({ url: `/photo/app/package/list/${shareCode}`, params })
}

export function getPackageDetail(shareCode, id) {
  return request({ url: `/photo/app/package/${shareCode}/${id}` })
}

export function createBooking(shareCode, data) {
  return request({ url: `/photo/app/booking/${shareCode}`, method: 'POST', data })
}
