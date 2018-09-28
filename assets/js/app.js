import '@scss/app.scss';

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

import '@js/components/globals';
import '@js/plugins'

import Breakbench from './breakbench';
import router from '@js/router';
import store from '@js/store';
import apolloProvider from '@js/utils/apollo-provider';

// Do not warn about using the dev version of Vue in development
Vue.config.productionTip = process.env.NODE_ENV === 'production'

const app = new Vue({
  router,
  store,
  apolloProvider,
  render: h => h(Breakbench),
});

if (document.getElementById('vue-app')) {
  app.$mount('#vue-app');
}
