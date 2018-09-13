import React, { Component } from 'react';
import debounce from 'lodash.debounce';
import { gql } from '../utils';
import {
  AvField,
  AvForm
} from 'availity-reactstrap-validation';
import {
  Button,
  FormText,
  Label
} from 'reactstrap';

const fieldClasses = {
  groupAttrs: {
    className: 'bb-form__form-group'
  },
  labelClass: 'bb-form__form-group--label',
  inputClass: 'bb-form__form-group--input'
};

const activateValidation = (value, input) => {
  const { name } = input.props;
  const { isTouched, setTouched } = input.context.FormCtrl;

  (value && !isTouched(name)) && setTouched(name)
};

const validateUsername = (async) => ({
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
  async: async
});

const validateEmail = (async) => ({
  required: {
    value: true,
    errorMessage: 'Please enter an email address'
  },
  email: {
    value: true,
    errorMessage: 'Your email address is invalid'
  },
  async: async
});

const validatePassword = (async) => ({
  required: {
    value: true,
    errorMessage: 'Please enter a password'
  },
  minLength: {
    value: 8,
    errorMessage: 'Must be 8 characters or more'
  },
  async: async
});

class RegisterForm extends Component {
  constructor(props) {
    super(props);

    this.state = {
      username: '',
      fullname: '',
      email: '',
      password: ''
    };

    const { username } = this.state;
  }

  static defaultProps = {
    onSubmit: () => {},
    onValidSubmit: () => {},
    onInvalidSubmit: () => {}
  }

  asyncUsername = debounce((value, ctx, input, callback) => {
    activateValidation(value, input);

    if (value && value.length >= 5) {
      gql.query(`($username: String!) {
        hasUser( username: $username )
      }`, {
        username: value
      }).then(data => {
        if (data && data.hasUser) {
          callback('Username is already taken');
        } else {
          callback(true);
        }
      });
    } else {
      callback(true);
    }
  }, 300)

  asyncEmail = debounce((value, ctx, input, callback) => {
    activateValidation(value, input);

    if (value && value.length >= 5) {
      gql.query(`($email: String!) {
        hasUser( email: $email )
      }`, {
        email: value
      }).then(data => {
        if (data && data.hasUser) {
          callback('Email address is already taken');
        } else {
          callback(true);
        }
      });
    } else {
      callback(true);
    }
  }, 300)

  asyncPassword = debounce((value, ctx, input, callback) => {
    activateValidation(value, input);
    callback(true);
  }, 300)

  handleChange = (e) => {
    e.preventDefault();

    const { name, value } = e.target;
    this.setState({ [name]: value });
  }

  handleSubmit = (event, errors, values) => {
    const { onSubmit } = this.props;
    onSubmit(event, errors, values);
  }

  handleValidSubmit = (event, values) => {
    const { onValidSubmit } = this.props;
    onValidSubmit(event, values);
  }

  handleInvalidSubmit = (event, errors, values) => {
    const { onInvalidSubmit } = this.props;
    onInvalidSubmit(event, errors, values);
  }

  render() {
    return (
      <AvForm
        className='bb-form'
        onSubmit={this.handleSubmit}
        onValidSubmit={this.handleValidSubmit}
        onInvalidSubmit={this.handleInvalidSubmit}
      >
        <AvField
          {...fieldClasses}
          label='Username'
          name='username'
          type='text'
          value={this.username}
          placeholder='username'
          onChange={this.handleChange}
          helpMessage='This will be your username.'
          validate={validateUsername(this.asyncUsername)}
        />
        <AvField
          {...fieldClasses}
          label='Email address'
          name='email'
          type='email'
          value={this.email}
          placeholder='email@example.com'
          onChange={this.handleChange}
          helpMessage='We’ll never share your email address with anyone.'
          validate={validateEmail(this.asyncEmail)}
        />
        <AvField
          {...fieldClasses}
          label='Password'
          name='password'
          type='password'
          value={this.password}
          placeholder='•••••••'
          onChange={this.handleChange}
          helpMessage='Use at least one lowercase letter, one numeral, and seven characters.'
          validate={validatePassword(this.asyncPassword)}
        />
        <Button
          className='bb-form__submit'
          type='submit'
          size='lg'
          block
        >
          Create new account
        </Button>
      </AvForm>
    );
  }
};

export default RegisterForm;
