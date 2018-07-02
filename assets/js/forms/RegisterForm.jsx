import React, { Component } from 'react';
import { connect } from 'react-redux';
import { AvForm, AvField } from 'availity-reactstrap-validation';
import { Button, Label, FormText } from 'reactstrap';
import _debounce from 'lodash.debounce';

import { flashActions, userActions } from '../actions';
import { userService } from '../services';
import { Logo } from '../icons';
import { Flash } from '../components';


class RegisterForm extends Component {
  constructor(props) {
    super(props);

    this.state = {
      user: {
        username: '',
        fullname: '',
        email: '',
        password: ''
      }
    };
  }
  componentDidMount = () => {
    console.log(this);
  }

  handleChange = (event) => {
    event.preventDefault();

    const { user } = this.state;
    const { name, value } = event.target;

    this.setState({ user: { ...user, [name]: value } });
  }

  handleSubmit = (event) => {
    const { user } = this.state;
    const { dispatch } = this.props;

    if (user.username && user.fullname && user.email && user.password) {
      dispatch(userActions.register(user));
    } else {
      dispatch(flashActions.error('This field is required'));
    }
  }

  validateInstantly = _debounce((value, ctx, input, cb) => {
    (value && !input.context.FormCtrl.isTouched(input.props.name)) &&
      input.context.FormCtrl.setTouched(input.props.name);

    cb(true)
  }, 300)

  validateUsername = _debounce((value, ctx, input, cb) => {
    (value && !input.context.FormCtrl.isTouched(input.props.name)) &&
      input.context.FormCtrl.setTouched(input.props.name);

    if (value && value.length >= 5)
      userService.check_username(value)
        .then(data => {
          if (data.data && data.data.hasUser !== false)
            cb('Username is already taken')
          else
            cb(true)
        });
    else
      cb(true);
  }, 300);

  validateEmail = _debounce((value, ctx, input, cb) => {
    (value && !input.context.FormCtrl.isTouched(input.props.name)) &&
      input.context.FormCtrl.setTouched(input.props.name);

    if (value)
      userService.check_email(value)
        .then(data => {
          if (data.data && data.data.hasUser !== false)
            cb('Email address is already taken')
          else
            cb(true)
        });
    else
      cb(true)
  }, 300);

  render() {
    const { flash } = this.props;
    const { user } = this.state;

    return (
      <div className='container-fluid form-container'>
        <div className='form-container-header'></div>
        <div className='form-container-body'>
          <div className='register-form'>
            <div className='form-box'>
              <AvForm onSubmit={this.handleSubmit}>
                <AvField
                  label='Username'
                  name='username'
                  type='text'
                  value={this.username}
                  placeholder='username'
                  onChange={this.handleChange}
                  helpMessage='This will be your username.'
                  validate={{
                    required: {
                      value: true,
                      errorMessage: 'Please enter a username'
                    },
                    pattern: {
                      value: '^[A-Za-z0-9_]+$',
                      errorMessage: 'Your username must be composed only with letter, numbers, and underscore'
                    },
                    minLength: {
                      value: 5,
                      errorMessage: 'Must be 5 characters or more'
                    },
                    maxLength: {
                      value: 16,
                      errorMessage: 'Must be 16 characters or less'
                    },
                    async: this.validateUsername
                  }}
                />

                <AvField
                  label='Email address'
                  name='email'
                  type='email'
                  value={this.email}
                  placeholder='email@example.com'
                  onChange={this.handleChange}
                  helpMessage='We’ll never share your email address with anyone.'
                  validate={{
                    required: {
                      value: true,
                      errorMessage: 'Please enter an email address'
                    },
                    email: {
                      value: true,
                      errorMessage: 'Your email address is invalid'
                    },
                    async: this.validateEmail
                  }}
                />

                <AvField
                  label='Password'
                  name='password'
                  type='password'
                  value={this.password}
                  placeholder='•••••••'
                  onChange={this.handleChange}
                  helpMessage='Use at least one lowercase letter, one numeral, and seven characters.'
                  validate={{
                    required: {
                      value: true,
                      errorMessage: 'Please enter a password'
                    },
                    minLength: {
                      value: 8,
                      errorMessage: 'Must be 8 characters or more'
                    },
                    async: this.validateInstantly
                  }}
                />

                <Button
                    block
                    className='submit'
                    type='submit'
                    size='lg'>
                  Create new account
                </Button>
              </AvForm>
            </div>
            <div className='form-flash'>
              {flash.message && <Flash />}
            </div>
            <div className='form-callout'>
              <div>
                Have an account? <a href='login'>Log in</a>
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
  return { flash };
}

const connectedRegisterForm = connect(mapStateToProps)(RegisterForm);
export { connectedRegisterForm as RegisterForm };
