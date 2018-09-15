import { combineReducers } from 'redux';
import { reducer as reduxFormReducer } from 'redux-form';
import * as reducers from './reducers';

const rootReducer = combineReducers({
  form: reduxFormReducer,
  ...reducers
});

export default rootReducer;
