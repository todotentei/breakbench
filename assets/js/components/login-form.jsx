import React, { Component } from 'react';
import {
  Button,
  Form,
  FormGroup,
  Label,
  Input
} from 'reactstrap';

class LoginForm extends Component {
  constructor(props) {
    super(props);

    this.state = {
      username_or_email: '',
      password: ''
    };
  }

  handleChange = (e) => {
    e.preventDefault();

    const { name, value } = e.target;
    this.setState({ [name]: value });

    const { onChange } = this.props;
    if (onChange) onChange({ name, value });
  }

  handleSubmit = (e) => {
    e.preventDefault();

    const { onSubmit } = this.props;
    if (onSubmit) onSubmit(e);
  }

  render() {
    const { username_or_email, password } = this.state;

    return (
      <Form
        className='login-form'
        onSubmit={this.handleSubmit}
      >
        <FormGroup className='login-form__form-group'>
          <Label className='login-form__form-group--label'>
            Username or email address
          </Label>
          <Input
            name='username_or_email'
            type='text'
            value={username_or_email}
            onChange={this.handleChange}
          />
        </FormGroup>

        <FormGroup className='login-form__form-group'>
          <Label className='login-form__form-group--label'>
            Password
          </Label>
          <Input
            name='password'
            type='password'
            value={password}
            onChange={this.handleChange}
          />
        </FormGroup>

        <div className='login-form__forgot-password'>
          <button type='button'>
            Forgot your password?
          </button>
        </div>

        <Button
          className='login-form__submit'
          type='submit'
          size='lg'
          block
        >
          Sign in to your account
        </Button>
      </Form>
    );
  }
};

export default LoginForm;
