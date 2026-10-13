const { request } = require('./request')

function getHome(shareCode) {
  return request({ url: `/photo/app/home/${shareCode}` })
}

function getAbout(shareCode) {
  return request({ url: `/photo/app/about/${shareCode}` })
}

function getWorkCategories(shareCode) {
  return request({ url: `/photo/app/work/category/${shareCode}` })
}

function getWorks(shareCode, params) {
  return request({ url: `/photo/app/work/list/${shareCode}`, params })
}

function getWorkDetail(shareCode, id) {
  return request({ url: `/photo/app/work/${shareCode}/${id}` })
}

function getPackages(shareCode, params) {
  return request({ url: `/photo/app/package/list/${shareCode}`, params })
}

function getPackageDetail(shareCode, id) {
  return request({ url: `/photo/app/package/${shareCode}/${id}` })
}

function createBooking(shareCode, data) {
  return request({ url: `/photo/app/booking/${shareCode}`, method: 'POST', data })
}

module.exports = {
  getHome,
  getAbout,
  getWorkCategories,
  getWorks,
  getWorkDetail,
  getPackages,
  getPackageDetail,
  createBooking
}
