<script>
  import config from './config'
  import { getToken } from '@/utils/auth'

  export default {
    onLaunch: function() {
      this.initApp()
    },
    methods: {
      // 初始化应用
      initApp() {
        // 初始化应用配置
        this.initConfig()
        // 检查用户登录状态
        //#ifdef H5
        this.checkLogin()
        //#endif
      },
      initConfig() {
        this.globalData.config = config
      },
      checkLogin() {
        let current = ''
        //#ifdef H5
        if (typeof window !== 'undefined' && window.location && window.location.hash) {
          current = window.location.hash.replace(/^#/, '').split('?')[0]
        }
        //#endif
        const pages = getCurrentPages()
        if (!current) {
          current = pages && pages.length ? '/' + pages[pages.length - 1].route : ''
        }
        if (current.indexOf('/pages/photonest/guest/') === 0) {
          return
        }
        if (!getToken()) {
          this.$tab.reLaunch('/pages/login') 
        }
      }
    }
  }
</script>

<style lang="scss">
  @import '@/static/scss/index.scss'
</style>
