import api from '@/api';

export default {
  state: {
    sku: null,
  },
  actions: {
    findSku: ({ commit }, { id, idType }) => api.sku.find([id], idType).then(sku => commit('findSku', sku)),
    clearSku: ({ commit }) => commit('clearSku'),
  },
  mutations: {
    findSku: (state, { skus }) => {
      state.sku = skus && skus[0];
    },
    clearSku: (state) => {
      state.sku = null;
    },
  },
  getters: {
    sku: state => state.sku,
  },
};
