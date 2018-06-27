import { flashConstants } from "../constants";

export const flashActions = {
  success,
  error,
  clear
};

function success(message) {
  return { type: flashConstants.SUCCESS, message }
}

function error(message) {
  return { type: flashConstants.ERROR, message };
}

function clear() {
  return { type: flashConstants.CLEAR };
}
