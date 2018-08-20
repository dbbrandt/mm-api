import axios from 'axios';

const API_ROOT = '/api';
const BOOTSTRAP = '/bootstrap';
const SKU_CHANGE_FLAG = '/sku_change_flags';
const SKU_IMAGES = '/sku_images';
const SKUS = '/skus';
const GOALS = '/goals';
<<<<<<< HEAD
const INTERACTIONS = '/interactions';
=======
const INTERACTIONS = '/goals/1/interactions';
>>>>>>> Initial Vue Commit with Build
const PRICE_AND_COST_CHANGE_REQUESTS = '/price_and_cost_change_request';

const endpoint = resource => API_ROOT + resource;

const isUnauthorized = error =>
  error.response === undefined
    || [401, 403].includes(error.response.status)
    || error.request.responseURL.includes('users/sign_in');

const handleError = (error) => {
  /* eslint-disable no-alert */
  if (isUnauthorized(error)) {
    // e.g. logged out due to running a resque job?
    if (window.confirm('Not Authorized: Open a new window to log in?')) {
      window.open('/', 'confirmLogin');
    }
  } else {
    const { response: { statusText, status, data } } = error;
    const message = `${statusText} (${status}) ${(data && data.message) || ''}`;
    window.alert(`API Problem\n\n${message}`);
  }
};

export default {
  bootstrap() {
    return axios.get(`${endpoint(BOOTSTRAP)}`).catch(handleError);
  },
  skuChangeFlag: {
    find(ids, idType) {
      // http://localhost:3000/api/sku_change_flags?sku_ids=1,2,3,10
      const params = {};
      params[`${idType}s`] = ids.join(',');
      return axios.put(endpoint(SKU_CHANGE_FLAG), params)
        .then(response => response.data)
        .catch(handleError);
    },
    update(skus, flags) {
      // http://localhost:3000/api/sku_change_flags?sku_ids=1,2,3,10
      return axios.post(`${endpoint(SKU_CHANGE_FLAG)}/set`, {
        sku_ids: skus.map(sku => sku.sku_id).join(','),
        flags,
      }).catch(handleError);
    },
  },
  skuImage: {
    find(id, idType) {
      // http://localhost:3000/api/sku_images?sku_id=1 or product_id=2 or base_product_id=3
      const params = {};
      params[`${idType}`] = id;
      return axios.get(`${endpoint(SKU_IMAGES)}`, { params })
        .then(response => response.data)
        .catch(handleError);
    },
  },
  priceAndCostChangeRequests: {
    findBySku(ids, idType, activeOnly, newestForSku) {
      const params = {
        active_only: activeOnly,
        newest_per_sku: newestForSku,
      };
      params[`${idType}s`] = ids.join(',');
      return axios.put(`${endpoint(PRICE_AND_COST_CHANGE_REQUESTS)}`, params)
        .then(response => response.data)
        .catch(handleError);
    },
    cancel: id => axios.delete(`${endpoint(PRICE_AND_COST_CHANGE_REQUESTS)}/${id}`).then(response => response.data).catch(handleError),
  },
  goals: {
    index() {
      return axios.get(`${endpoint(GOALS)}`)
        .then(response => response.data)
        .catch(handleError);
    },
  },
  interactions: {
<<<<<<< HEAD
    index(goal, size) {
      return axios.get(`${endpoint(GOALS)}/${goal}${INTERACTIONS}`, { params: { size: `${size}`, deep: 'true' } })
=======
    index(size) {
      return axios.get(`${endpoint(INTERACTIONS)}`, { params: { size: `${size}`, deep: 'true' } })
>>>>>>> Initial Vue Commit with Build
        .then(response => response.data)
        .catch(handleError);
    },
    show(id) {
      return axios.get(`${endpoint(INTERACTIONS)}`, { params: { id: `${id}`, deep: 'true' } })
        .then(response => response.data)
        .catch(handleError);
    },

  },
  sku: {
    find(ids, idType) {
      const params = {};
      params[`${idType}s`] = ids.join(',');
      return axios.put(`${endpoint(SKUS)}`, params)
        .then(response => response.data)
        .catch(handleError);
    },
    findFat(id) {
      return axios.get(`${endpoint(SKUS)}/${id}?fat=true`)
        .then(response => response.data)
        .catch(handleError);
    },
    duplicate(id, brandCode) {
      return axios.put(`${endpoint(SKUS)}/${id}/duplicate?brand_code=${brandCode}`)
        .then(response => response.data)
        .catch(handleError);
    },

  },
};
