import { combineReducers } from 'redux';

import { alert } from './alert.reducer';
import { flash } from './flash.reducer';
import { logged } from './logged.reducer';

const rootReducer = combineReducers({
  alert,
  flash,
  logged
})

export default rootReducer;
