import '../scss/app.scss';

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from 'config.paths.watched'.
import 'phoenix_html';

// Import local files
//
// Local files can be imported directly using relative
// paths './socket' or full ones 'web/static/js/socket'.

// import socket from './socket'

// Vue
import Vue from 'vue';
import App from './breakbench';
import router from '@router';
import store from '@state/store';

import '@components/_globals';

// Do not warn about using the dev version of Vue in development
Vue.config.productionTip = process.env.NODE_ENV === 'production'

const app = new Vue({
  router,
  store,
  render: h => h(App),
}).$mount('#app')
