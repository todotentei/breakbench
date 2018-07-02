import Axios from "axios";

export const userService = {
  check_email,
  check_username,
  login,
  register
};


function check_email(email) {
  return request({
    method: "post",
    url: "/api/graphiql",
    data: { query: ` query { hasUser(email: "${email}") }` }
  })
}

function check_username(username) {
  return request({
    method: "post",
    url: "/api/graphiql",
    data: { query: ` query { hasUser(username: "${username}") }` }
  });
}

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
    .then(response => response.data)
    .catch(error => { console.log(error); });
}
