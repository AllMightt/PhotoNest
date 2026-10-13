import request from '@/utils/request'

export function getHome(shareCode) {
  return request({
    url: `/photo/app/home/${shareCode}`,
    method: 'get',
    headers: { isToken: false }
  })
}

export function getWorkCategories(shareCode) {
  return request({
    url: `/photo/app/work/category/${shareCode}`,
    method: 'get',
    headers: { isToken: false }
  })
}

export function getWorks(shareCode, params) {
  return request({
    url: `/photo/app/work/list/${shareCode}`,
    method: 'get',
    params,
    headers: { isToken: false }
  })
}

export function getWorkDetail(shareCode, id) {
  return request({
    url: `/photo/app/work/${shareCode}/${id}`,
    method: 'get',
    headers: { isToken: false }
  })
}

export function getPackages(shareCode, params) {
  return request({
    url: `/photo/app/package/list/${shareCode}`,
    method: 'get',
    params,
    headers: { isToken: false }
  })
}

export function createBooking(shareCode, data) {
  return request({
    url: `/photo/app/booking/${shareCode}`,
    method: 'post',
    data,
    headers: { isToken: false }
  })
}
