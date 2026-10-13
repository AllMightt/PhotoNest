const LOCAL_FILE_HOSTS = [
  'http://localhost:9300',
  'http://127.0.0.1:9300',
  'http://[::1]:9300'
]

export function normalizeFileUrl(url) {
  if (!url || typeof url !== 'string') {
    return url
  }
  let normalized = url
  LOCAL_FILE_HOSTS.forEach(host => {
    if (normalized.startsWith(host)) {
      normalized = normalized.replace(host, import.meta.env.VITE_APP_BASE_API)
    }
  })
  return normalized
}

export function normalizeFileUrlList(urls) {
  if (!urls || typeof urls !== 'string') {
    return urls
  }
  return urls.split(',').map(item => normalizeFileUrl(item)).join(',')
}
