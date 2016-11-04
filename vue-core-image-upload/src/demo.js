var Vue = require('vue');

var VueCoreImageUpload = require('./vue.core.image.upload');

Vue.config.debug = false;
Vue.config.silent = false;
Vue.config.async = false;
Vue.config.devtools = false;

new Vue({
  el: '#app',
  components: {
    'vue-core-image-upload': VueCoreImageUpload
  },
  data: {
    name: 'Jiraiya',
    src: 'http://img1.vued.vanthink.cn/vued0a233185b6027244f9d43e653227439a.png',
    cropSrc: 'http://img1.vued.vanthink.cn/vued7553a09a5d5209ebd00a48264394b7f3.png',
    cropArgs: {},
  },
  methods: {

  },
  events: {
    imageuploaded(res) {
      if (res.errcode == 0) {
        if(res.data.src) {
          this.src = res.data.src;
          return;
        }
        this.name = res.data.name;
        this.cropArgs = {
          toCropImgH: parseInt(res.data.post.toCropImgH),
          toCropImgW: parseInt(res.data.post.toCropImgW),
          toCropImgX: parseInt(res.data.post.toCropImgX),
          toCropImgY: parseInt(res.data.post.toCropImgY)
        }
        this.cropSrc = 'http://img1.vued.vanthink.cn/vued41b900045d6d44f3b32e06049621b415.png';
        
        
      }
    },
    errorHandle: function(msg) {
      console.warn(msg);
    }
    
  },
});