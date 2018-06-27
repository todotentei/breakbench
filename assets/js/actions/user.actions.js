import { userConstants } from "../constants";
import { userService } from "../services";
import { flashActions } from "./";
import { history } from "../helpers"

export const userActions = {
  login,
  register
};

function login(login, password) {
  return dispatch => {
    dispatch(request({ login }));

    userService.login(login, password)
      .then(
        data => {
          if (data.type === "ok") {
            dispatch(success(data));
            history.push("/");
          } else {
            const error = data.message || "unexpected error";
            dispatch(failure(error.toString()));
            dispatch(flashActions.error(error.toString()));
          }
        },
        error => {
          dispatch(failure(error.toString()));
          dispatch(flashActions.error(error.toString()));
        }
      );
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
          history.push('/login');
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
