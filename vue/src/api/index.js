import implementation from '@/api/implementation';
import mock from '@/api/mock';

const USE_MOCK = false;

const api = USE_MOCK ? mock : implementation;

export default {
  bootstrap: api.bootstrap,
  skuChangeFlag: {
    find(ids, idType) {
      return api.skuChangeFlag.find(ids, idType);
    },
    update(skus, flags) {
      return api.skuChangeFlag.update(skus, flags);
    },
  },
  goals: {
    index() {
      return api.goals.index();
    },
  },
  interactions: {
    index(goal, size) {
      return api.interactions.index(goal, size);
    },
    show(id) {
      return api.interactions.show(id);
    },
  },
  skuImage: {
    find(id, idType) {
      return api.skuImage.find(id, idType);
    },
  },
  priceAndCostChangeRequests: {
    findBySku(ids, idType, activeOnly, newestForSku) {
      return api.priceAndCostChangeRequests.findBySku(ids, idType, activeOnly, newestForSku);
    },
    cancel: id => api.priceAndCostChangeRequests.cancel(id),
  },
  sku: {
    find(id, idType) {
      return api.sku.find(id, idType);
    },
    findFat(id) {
      return api.sku.findFat(id);
    },
    duplicate(id, brandId) {
      return api.sku.duplicate(id, brandId);
    },
  },
};
