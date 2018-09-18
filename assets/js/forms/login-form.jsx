import React from 'react';
import { Field, reduxForm } from 'redux-form';

const renderField = ({ input, id, placeholder, type }) => (
  <div className='web-form-group'>
    <input
      {...input}
      type={type}
      placeholder={placeholder}
      className='web-form-control'
    />
  </div>
);

const LoginForm = (props) => {
  return (
    <form onSubmit={props.handleSubmit}>
      <Field
        id='username_or_email'
        name='username_or_email'
        type='text'
        component={renderField}
        placeholder='Username or email address'
      />
      <Field
        id='password'
        name='password'
        type='password'
        component={renderField}
        placeholder='Password'
      />
      <div className='web-form-group'>
        <button
          type='button'
          className='web-button-link web-text-small'
        >
          Forgot your password?
        </button>
      </div>
      <button
        type='submit'
        className='web-button web-button-primary'
      >
        Sign in to your account
      </button>
    </form>
  );
};

export default reduxForm({
  form: 'login-form',
  initialValues: {
    username_or_email: '',
    password: ''
  }
})(LoginForm);
