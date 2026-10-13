function maskPhone(phone) {
  const normalized = String(phone || '').trim()
  if (!/^1\d{10}$/.test(normalized)) {
    return normalized
  }
  return `${normalized.slice(0, 3)}****${normalized.slice(7)}`
}

module.exports = {
  maskPhone
}
