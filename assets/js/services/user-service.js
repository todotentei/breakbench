import Axios from 'axios';

const register = (user) => {
  console.log(user);
  return Axios({
    method: 'post',
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-Token': window.csrf_token
    },
    url: '/register',
    data: { user }
  })
  .then(resp => {
    const { data } = resp;

    switch (resp.status) {
      case 201:
        return data;
      default:
        const message = (data && data.message) || resp.statusText;
        return Promise.reject(message);
    };
  });
};

export default { register };
