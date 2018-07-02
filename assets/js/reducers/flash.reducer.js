import { flashConstants } from "../constants";

export function flash(state = {}, action) {
  switch (action.type) {
    case flashConstants.SUCCESS:
      return {
        class: 'flash-success',
        message: action.message
      };
    case flashConstants.ERROR:
      return {
        class: 'flash-danger',
        message: action.message
      };
    case flashConstants.CLEAR:
      return {};
    default:
      return state
  }
};
