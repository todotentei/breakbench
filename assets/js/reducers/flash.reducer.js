import { flashConstants } from "../constants";

export function flash(state = {}, action) {
  switch (action.type) {
    case flashConstants.SUCCESS:
      return {
        type: 'flash-success',
        message: action.message
      };
    case flashConstants.ERROR:
      return {
        type: 'flash-danger',
        message: action.message
      };
    case flashConstants.CLEAR:
      return {};
    default:
      return state
  }
};
