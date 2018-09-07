import { authenticatedC } from '../constants';

const success = () => ({
  type: authenticatedC.SUCCESS
});

const error = () => ({
  type : authenticatedC.ERROR
});

export default { success, error };
