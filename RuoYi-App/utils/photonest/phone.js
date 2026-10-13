export function maskPhone(phone) {
  const value = String(phone || '').trim()
  if (!/^1\d{10}$/.test(value)) {
    return value
  }
  return `${value.slice(0, 3)}****${value.slice(7)}`
}
