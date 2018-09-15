import React from 'react';
import { Route } from 'react-router-dom';
import {
  HomePage,
  LoginPage,
  RegisterPage
} from './pages';

const routes = (
  <main id='main' role='main' className='app-content'>
    <Route exact path='/' component={HomePage} />
    <Route exact path='/login' component={LoginPage} />
    <Route exact path='/register' component={RegisterPage} />
  </main>
);

export default routes;
