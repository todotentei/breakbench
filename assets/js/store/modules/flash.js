export const state = {
  type: '',
  message: ''
};

export const actions = {
  danger: ({ commit }, message) => {
    commit('danger', message);
  },
  warning: ({ commit }, message) => {
    commit('warning', message);
  },
  info: ({ commit }, message) => {
    commit('info', message);
  },
  success: ({ commit }, message) => {
    commit('success', message);
  },
  clear: ({ commit }) => {
    commit('clear');
  },
};

export const mutations = {
  danger: (state, message) => {
    state.type = 'flash-danger';
    state.message = message;
  },
  warning: (state, message) => {
    state.type = 'flash-warning';
    state.message = message;
  },
  info: (state, message) => {
    state.type = 'flash-info';
    state.message = message;
  },
  success: (state, message) => {
    state.type = 'flash-success';
    state.message = message;
  },
  clear: (state) => {
    state.type = '';
    state.message = '';
  },
}
