import { loggedConstants } from '../constants';

export const loggedActions = {
  success,
  error
};

function success() {
  return { type: loggedConstants.SUCCESS }
}

function error() {
  return { type: loggedConstants.ERROR }
}
