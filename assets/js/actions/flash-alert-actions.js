import { flashAlertC } from '../constants';

const success = (message) => ({
  type: flashAlertC.SUCCESS,
  message
});

const error = (message) => ({
  type: flashAlertC.ERROR,
  message
});

const clear = () => ({
  type: flashAlertC.CLEAR
});

export default { success, error, clear };
