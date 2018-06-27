import { combineReducers } from 'redux';

import { authentication } from './authentication.reducer';
import { alert } from './alert.reducer';
import { flash } from './flash.reducer';

const rootReducer = combineReducers({
  authentication,
  alert,
  flash
})

export default rootReducer;
