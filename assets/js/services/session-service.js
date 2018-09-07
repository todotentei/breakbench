import Axios from 'axios';

const login = (user) => {
  return Axios({
    method: 'post',
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-Token': window.csrf_token
    },
    url: '/login',
    data: { session: { ...user } }
  })
  .then(resp => {
    const { data } = resp;

    switch (resp.status) {
      case 200:
        return data;
      default:
        const message = (data && data.message) || resp.statusText;
        return Promise.reject(message);
    };
  });
};

export default { login };
