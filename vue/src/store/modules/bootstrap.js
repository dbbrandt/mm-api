import api from '@/api';

export default {
  state: {
    bootstrap: {},
  },
  actions: {
    refreshBootstrap: ({ commit }) => api.bootstrap().then(({ data }) => commit('refreshBootstrap', data.bootstrap)),
  },
  mutations: {
    refreshBootstrap: (state, bootstrap) => {
      state.bootstrap = bootstrap;
    },
  },
  getters: {
    config: state => (application, key) => state.bootstrap.config[application][key],
    user: state => state.bootstrap.user,
    isPowerUser: state => state.bootstrap.user && state.bootstrap.user.power_user,
    hasRole: state => role => state.bootstrap.user && state.bootstrap.user.roles.includes(role),
    apiLimit: state => apiName => state.bootstrap.user && state.bootstrap.user.api_limits
      && state.bootstrap.user.api_limits[apiName],
    globalNav: state => state.bootstrap.global_nav,
  },
};
