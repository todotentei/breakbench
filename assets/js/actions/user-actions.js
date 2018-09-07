import { userService } from '../services';
import { userC } from '../constants';
import { flashAlertActions } from '../actions';

const register = (user) => {
  const request = () => ({
    type: userC.register.REQUEST
  });

  const success = () => ({
    type: userC.register.SUCCESS
  });

  const error = () => ({
    type: userC.register.ERROR
  });

  return (dispatch) => {
    dispatch(request());

    userService.register(user)
      .then(data => {
        const message = (data && data.message) || 'Register successfully';

        dispatch(success());
        dispatch(flashAlertActions.success(message));
      }, err => {
        console.log(err);
        const { data } = err.response;
        const message = (data && data.message) || err.response.statusText;

        dispatch(error());
        dispatch(flashAlertActions.error(message));
      });
  };
};

export default { register };
