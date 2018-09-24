import Vue from 'vue';
import Vuex from 'vuex';
import VueForm from 'vue-form';

import modules from './modules';

Vue.use(Vuex);
Vue.use(VueForm);

const store = new Vuex.Store({
  modules,
  strict: process.env.NODE_ENV !== 'production',
});

// Automatically run the `init` action for every module,
// if one exists.
for (const moduleName of Object.keys(modules)) {
  if (modules[moduleName].actions && modules[moduleName].actions.init) {
    store.dispatch(`${moduleName}/init`);
  }
}

export default store;
