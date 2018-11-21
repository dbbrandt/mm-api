export default {
  state: {
    selection: {
      ids: [],
      type: 'bbb_sku_id',
    },
  },
  actions: {
    updateSelectionIds: ({ commit }, ids) => commit('updateSelectionIds', ids),
    updateSelectionType: ({ commit }, type) => commit('updateSelectionType', type),
  },
  mutations: {
    updateSelectionIds: (state, ids) => {
      state.selection.ids = ids;
    },
    updateSelectionType: (state, type) => {
      state.selection.type = type;
    },
  },
  getters: {
    selection: state => state.selection,
  },
};
