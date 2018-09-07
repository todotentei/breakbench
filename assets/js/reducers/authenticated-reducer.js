import { authenticatedC } from '../constants';

const authenticated = (state = false, action) => {
  switch (action.type) {
    case authenticatedC.SUCCESS:
      return true;
    case authenticatedC.ERROR:
      return false;
    default:
      return state;
  }
};

export default authenticated;
