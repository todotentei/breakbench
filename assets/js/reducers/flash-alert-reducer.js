import { flashAlertC } from '../constants';

const flashAlert = (state = {}, action) => {
  switch (action.type) {
    case flashAlertC.SUCCESS:
      return {
        type: 'flash-alert--success',
        message: action.message
      };
    case flashAlertC.ERROR:
      return {
        type: 'flash-alert--danger',
        message: action.message
      };
    case flashAlertC.CLEAR:
      return {};
    default:
      return state;
  }
}

export default flashAlert;
