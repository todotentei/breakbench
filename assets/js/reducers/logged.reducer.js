import { loggedConstants } from "../constants";

export function logged(state = {}, action) {
  switch (action.type) {
    case loggedConstants.SUCCESS:
      return { status: true }
    case loggedConstants.ERROR:
      return { status: false }
    default:
      return state
  }
};
