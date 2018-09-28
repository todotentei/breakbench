import axios from 'axios';

const register = (user) => {
  return axios({
    method: 'post',
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-TOKEN': window.csrf_token
    },
    url: '/register',
    data: { user }
  }).then((response) => {
    switch (response.status) {
      case 201:
        return response.data;
      default:
        const message = (data && data.message) || resp.statusText;
        return Promise.reject(message);
    };
  });
};

export default { register };
