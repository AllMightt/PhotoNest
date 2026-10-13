function normalizeFileUrl(url) {
  if (!url || typeof url !== 'string') {
    return url
  }
  return url.replace('http://127.0.0.1:9300', 'http://localhost:9300')
}

function normalizeImageFields(item = {}, fields = []) {
  const next = { ...item }
  fields.forEach((field) => {
    if (next[field]) {
      next[field] = normalizeFileUrl(next[field])
    }
  })
  return next
}

module.exports = {
  normalizeFileUrl,
  normalizeImageFields
}
