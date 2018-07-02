import { userConstants } from "../constants";
import { userService } from "../services";
import { loggedActions, flashActions } from "./";
import { history } from "../helpers"
import _debounce from 'lodash.debounce';

export const userActions = {
  login,
  register
};


function login(login, password) {
  return dispatch => {
    dispatch(request({ login }));

    userService.login(login, password)
      .then(data => {
        if (data.status === "ok") {
          const message = data.message || "Welcome back!";
          dispatch(success(data));
          dispatch(loggedActions.success())
          history.push("/")
        } else if (data.status === "error") {
          const message = data.message || "Incorrect username or password";
          dispatch(failure(message.toString()));
          dispatch(loggedActions.error())
          dispatch(flashActions.error(message.toString()));
        } else {
          const message = "Unexpected error";
          dispatch(failure(message.toString()));
          dispatch(flashActions.error(message.toString()));
        }
      }, error => {
        dispatch(failure(error.toString()));
        dispatch(flashActions.error(error.toString()));
      });
  };

  function request(data) { return { type: userConstants.LOGIN_REQUEST, data } };
  function success(data) { return { type: userConstants.LOGIN_SUCCESS, data } };
  function failure(data) { return { type: userConstants.LOGIN_FAILURE, data } };
}

function register(data) {
  return dispatch => {
    dispatch(request(data));

    userService.register(data)
      .then(
        data => {
          dispatch(success());
          dispatch(flashActions.success('Registration successful'));
        },
        error => {
          dispatch(failure(error.toString()));
          dispatch(flashActions.error(error.toString()));
        }
      );
  };

  function request(data) { return { type: userConstants.REGISTER_REQUEST, data } };
  function success(data) { return { type: userConstants.REGISTER_SUCCESS, data } };
  function failure(data) { return { type: userConstants.REGISTER_FAILURE, data } };
}
