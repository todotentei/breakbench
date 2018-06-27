import React, { Component } from 'react';
import { connect } from 'react-redux';
import {
  Form, Button, FormGroup, Label, Input
} from "reactstrap";

import { flashActions, userActions } from '../actions';
import { Logo } from "../icons";
import { Prompt } from '../components';

class LoginForm extends Component {
  constructor(props) {
    super(props);

    this.state = {
      login: '',
      password: ''
    };
  }

  handleFlashClose = (event) => {
    const { dispatch } = this.props;
    dispatch(flashActions.clear());
  }

  handleChange = (event) => {
    const { id, value } = event.target;
    this.setState({ [id]: value });
  }

  handleSubmit = (event) => {
    event.preventDefault();

    const { login, password } = this.state;
    const { dispatch } = this.props;

    if (login && password) {
      dispatch(userActions.login(login, password));
    } else {
      dispatch(flashActions.error('This field is required'));
    }
  }

  render() {
    const { flash } = this.props;
    const { login, password } = this.state;

    return (
      <div className='container-fluid form-container'>
        <div className='form-container-header'></div>
        <div className='form-container-body'>
          <div className='login-form'>
            <div className='form-box'>

              <div className="form-logo">
                <Logo height="48" width="48" />
              </div>

              <Form onSubmit={this.handleSubmit}>
                <FormGroup>
                  <Label for="login">Username or email address</Label>
                  <Input
                    autoFocus
                    id="login"
                    type="text"
                    name="login"
                    value={login}
                    onChange={this.handleChange}
                  />
                </FormGroup>

                <FormGroup>
                  <Label for="password">Password</Label>
                  <Input
                    id="password"
                    type="password"
                    name="password"
                    value={password}
                    onChange={this.handleChange}
                  />
                </FormGroup>

                <div className="forgot-password">
                  <button>Forgot your password?</button>
                </div>

                <Button
                    className="submit"
                    type="submit"
                    size="lg"
                    block>
                  Create new account
                </Button>
              </Form>
            </div>
            <div id='flash-container'>
              {flash.message &&
                <Prompt
                    className='prompt-danger'
                    onClose={this.handleFlashClose}>
                  {flash.message}
                </Prompt>
              }
            </div>
            <div className='form-callout'>
              <div>
                Don't have an account? <a href='register'>Sign up</a>
              </div>
            </div>
          </div>
        </div>
        <div className='form-container-footer'>
        </div>
      </div>
    );
  }
};

function mapStateToProps(state) {
  const { flash } = state;
  const { loggingIn } = state.authentication;

  return { flash, loggingIn };
}

const connectedLoginForm = connect(mapStateToProps)(LoginForm);
export { connectedLoginForm as LoginForm };
