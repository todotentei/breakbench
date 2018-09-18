import React, { Component } from 'react';
import { Field, reduxForm } from 'redux-form';
import classNames from 'classnames';
import { validate } from 'validate.js';

const validateForm = (values) => {
  return validate(values, {
    username: {
      presence: true
    },
    full_name: {
      presence: true
    },
    email: {
      presence: true
    },
    password: {
      presence: true
    },
  });
};

const renderField = ({ input, id, type, placeholder, label, meta }) => {
  const { touched, error } = meta;

  const errors = {input_class: '', text_class: ''};
  if (touched && error) {
    errors.input_class = 'web-form-control-danger';
    errors.text_class = 'web-text-danger'
  }

  const _iC = classNames('web-form-control', errors.input_class);
  const _fC = classNames('web-text-small text-danger', errors.feedback_class);

  return (
    <div className='web-form-group'>
      <label className='web-text-small text-bold'>{label}</label>
      <input {...input} type={type} className={_iC} placeholder={placeholder} />
      {touched && error &&
        <span className={_fC}>{error}</span>
      }
    </div>
  );
};

const RegisterForm = (props) => {
  return (
    <form onSubmit={props.handleSubmit}>
      <Field
        id='username'
        name='username'
        type='text'
        label='Username'
        placeholder='jsmith'
        component={renderField}
      />
      <Field
        id='fullname'
        name='full_name'
        type='text'
        label='Full name'
        placeholder='James Smith'
        component={renderField}
      />
      <Field
        id='email'
        name='email'
        type='email'
        label='Email address'
        placeholder='james.smith@example.com'
        component={renderField}
      />
      <Field
        id='password'
        name='password'
        type='password'
        label='Password'
        placeholder='•••••••'
        component={renderField}
      />
      <button type='submit' className='web-button web-button-primary'>
        Sign in to your account
      </button>
    </form>
  );
};

export default reduxForm({
  form: 'register-form',
  validate: validateForm
})(RegisterForm);
