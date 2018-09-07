import { sessionService } from '../services';
import { sessionC } from '../constants';
import {
  authenticatedActions,
  flashAlertActions
} from './';

const login = (user) => {
  const request = () => ({
    type: sessionC.login.REQUEST
  });

  const success = () => ({
    type: sessionC.login.SUCCESS
  });

  const error = () => ({
    type: sessionC.login.ERROR
  });

  return (dispatch) => {
    dispatch(request());

    sessionService.login(user)
      .then(data => {
        const message = (data && data.message) || 'Login successfully';

        dispatch(success());
        dispatch(authenticatedActions.success());
        dispatch(flashAlertActions.success(message));
      }, err => {
        const { data } = err.response;
        const message = (data && data.message) || err.response.statusText;

        dispatch(error());
        dispatch(authenticatedActions.error());
        dispatch(flashAlertActions.error(message));
      });
  };
};

export default { login };
