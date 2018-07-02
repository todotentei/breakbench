import React, { Component } from 'react';

import { LoginForm } from '../forms';
import { Logo } from '../icons';

export class LoginPage extends Component {
  render() {
    return (
      <div className="login-page">
        <LoginForm />
      </div>
    );
  }
};
