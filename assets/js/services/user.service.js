import Axios from "axios";

function login(login, password) {
  return request({
    method: "post",
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-Token": window.csrf_token
    },
    url: "/login",
    data: { session: { login, password } }
  });
}

function register(user) {
  return request({
    method: "post",
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-Token": window.csrf_token
    },
    url: "/register",
    data: { user }
  });
}

function request(options) {
  return Axios(options)
    .then(function(response) { return response.data; })
    .catch(function(error) { console.log(error); });
}

export const userService = {
  login,
  register
};
