import React from 'react';
import { Field, reduxForm } from 'redux-form';

const renderField = ({ input, id, label, type }) => (
  <div className='app-form-group'>
    <label className='text-small text-bold'>{label}</label>
    <input {...input} type={type} className='app-form-control' />
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
        label='Username or email address'
      />
      <Field
        id='password'
        name='password'
        type='password'
        component={renderField}
        label='Password'
      />
      <div className='app-form-group'>
        <button
          type='button'
          className='app-button-link text-small'
        >
          Forgot your password?
        </button>
      </div>
      <button
        type='submit'
        className='app-button app-button-primary'
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
