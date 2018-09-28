import Vue from 'vue';
import Vuex from 'vuex';
import VeeValidate from 'vee-validate';
import VueApollo from 'vue-apollo';

import dictionary from '@js/utils/vee-dictionary';

import '@js/utils/vee-validators';

Vue.use(Vuex);
Vue.use(VeeValidate, {
  dictionary,
});
Vue.use(VueApollo);
