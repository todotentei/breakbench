import { flashAlertC } from '../constants';

const flashAlert = (state = {}, action) => {
  switch (action.type) {
    case flashAlertC.SUCCESS:
      return {
        type: 'success',
        message: action.message
      };
    case flashAlertC.ERROR:
      return {
        type: 'danger',
        message: action.message
      };
    case flashAlertC.CLEAR:
      return {};
    default:
      return state;
  }
}

export default flashAlert;
