import axios from 'axios';

const login = (user) => {
  return axios({
    method: 'post',
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-TOKEN': window.csrf_token
    },
    url: '/login',
    data: { session: { ...user }}
  }).then((response) => {
    switch (response.status) {
      case 200:
        return response.data;
      default:
        const message = (data && data.message) || resp.statusText;
        return Promise.reject(message);
    };
  });
};

export default { login };
