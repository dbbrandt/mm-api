// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue';
import Vuetify from 'vuetify';
import 'vue-awesome/icons';
import VueClipboard from 'vue-clipboard2';
import Icon from 'vue-awesome/components/Icon';

import App from './App';
import store from './store/index';
import router from './router';

import DateTime from './components/DateTime';
import Pluralize from './components/Pluralize';
import Spinner from './components/Spinner';

Vue.use(Vuetify);
Vue.use(VueClipboard);

// globally (in your main .js file)
Vue.component('icon', Icon);
Vue.component('DateTime', DateTime);
Vue.component('Pluralize', Pluralize);
Vue.component('Spinner', Spinner);

Vue.config.productionTip = false;

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  store,
  template: '<App/>',
  components: { App },
});
