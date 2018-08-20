import Vue from 'vue';
import Vuex from 'vuex';
import bootstrap from './modules/bootstrap';
import priceAndCostChangeRequests from './modules/priceAndCostChangeRequests';
import selection from './modules/selection';
import sku from './modules/sku';

Vue.use(Vuex);

const store = new Vuex.Store({
  modules: {
    bootstrap,
    priceAndCostChangeRequests,
    selection,
    sku,
  },
});

export default store;
