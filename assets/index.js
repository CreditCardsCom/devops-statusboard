import Vue from 'vue'
import VueResource from 'vue-resource'
import Application from './application.vue';

// Vue.use(Store)

const App = new Vue({
  el:'#vue-app',
  name: 'App',
  render: h => h(Application)
})

