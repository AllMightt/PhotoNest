import axios from 'axios'

const service = axios.create({
  baseURL: import.meta.env.VITE_APP_BASE_API || '/dev-api',
  timeout: 15000
})

service.interceptors.request.use((config) => {
  const token = window.localStorage.getItem('photonest.photographer.token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

service.interceptors.response.use((response) => response.data)

export default service
