import api from '@/api';

// enhance raw object with derived fields
const decorate = (pccr) => {
  const priceChangeTask = pccr.tasks.find(task => task.type === 'price change');
  pccr.originalPrice = priceChangeTask && priceChangeTask.future_change.prior_value;
  pccr.priceChangeStatus = priceChangeTask && priceChangeTask.future_change.status;
  const costChangeTask = pccr.tasks.find(task => task.type === 'cost change');
  pccr.originalCost = costChangeTask && costChangeTask.future_change.prior_value;
  pccr.costChangeStatus = costChangeTask && costChangeTask.future_change.status;

  const priceRevertTask = pccr.tasks.find(task => task.type === 'price reversion');
  pccr.priceRevertStatus = priceRevertTask && priceRevertTask.future_change.status;
  const costRevertTask = pccr.tasks.find(task => task.type === 'cost reversion');
  pccr.costRevertStatus = costRevertTask && costRevertTask.future_change.status;
};

export default {
  state: {
    priceAndCostChangeRequests: [],
  },
  actions: {
    findPriceAndCostChangeRequestsForSku: ({ commit }, { ids, idType, activeOnly, newestForSku }) => api.priceAndCostChangeRequests.findBySku(ids, idType, activeOnly, newestForSku).then(skuAndRequests => commit('findPriceAndCostChangeRequestsForSku', skuAndRequests)),
    updatePriceAndCostChangeRequest: ({ commit }, priceAndCostChangeRequest) => commit('updatePriceAndCostChangeRequest', priceAndCostChangeRequest),
  },
  mutations: {
    findPriceAndCostChangeRequestsForSku: (state, {
      sku, price_and_cost_change_requests: priceAndCostChangeRequests,
    }) => {
      state.sku = sku;
      priceAndCostChangeRequests.forEach(decorate);
      state.priceAndCostChangeRequests = priceAndCostChangeRequests;
    },
    updatePriceAndCostChangeRequest: (state, priceAndCostChangeRequest) => {
      const match = state.priceAndCostChangeRequests.find(
        item => item.id === priceAndCostChangeRequest.id);
      if (match) {
        decorate(priceAndCostChangeRequest);
        const index = state.priceAndCostChangeRequests.indexOf(match);
        state.priceAndCostChangeRequests.splice(index, 1, priceAndCostChangeRequest);
      }
    },
  },
  getters: {
    priceAndCostChangeRequests: state => state.priceAndCostChangeRequests,
  },
};
