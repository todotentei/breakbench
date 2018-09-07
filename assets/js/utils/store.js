import { createStore, applyMiddleware } from 'redux';
import thunkMiddleware from 'redux-thunk';
import { createLogger } from 'redux-logger';
import rootReducer from '../root-reducer';

const loggerMiddleware = createLogger();
const middleware = applyMiddleware(
  thunkMiddleware,
  loggerMiddleware
);

const store = createStore(
  rootReducer,
  middleware
);

export default store;
