import React, { Component } from 'react';
import ReactDOM from "react-dom";
import { connect } from 'react-redux';
import { Button, Form, FormGroup, Label, Input } from 'reactstrap';

import { flashActions, userActions } from '../actions';
import { Logo } from '../icons';
import { Flash } from '../components';

class LoginForm extends Component {
  constructor(props) {
    super(props);

    this.state = {
      login: '',
      password: ''
    };
    this.bodyRef = React.createRef();
    this.formRef = React.createRef();
  }

  handleFocus = (event) => {
    event.preventDefault();

    const { flash } = this.props;
    const { dispatch } = this.props;

    if (Object.keys(flash).length != 0)
      dispatch(flashActions.clear())
  }

  handleChange = (event) => {
    event.preventDefault();

    const { name, value } = event.target;
    this.setState({ [name]: value });
  }

  handleSubmit = (event) => {
    event.preventDefault();

    const { login, password } = this.state;
    const { dispatch } = this.props;

    if (login && password)
      dispatch(userActions.login(login, password));
    else
      dispatch(flashActions.error('This field is required'));
  }

   componentWillReceiveProps = (nextProps) => {
     const { logged } = nextProps;

     if (logged && logged.status == true) {
       this.formRef.current.remove()
       ReactDOM.render((
         <div className="logged-welcoming">
           <div>
             <Logo height='48' width='48' />
           </div>
           <div>
             <h3>Welcome back!</h3>
             <p>We're so excited to see you again!</p>
             <p className="text-muted small">Page is redirecting...</p>
           </div>
         </div>
       ), this.bodyRef.current)
     }
  }

  render() {
    const { flash } = this.props;
    const { login, password } = this.state;

    return (
      <div ref={this.bodyRef} className='container-fluid form-container'>
        <div ref={this.formRef} className='login-form'>
          <div className='form-box'>
          {
            // <div className='form-logo'>
            //   <Logo height='48' width='48' />
            // </div>
          }

            <Form onSubmit={this.handleSubmit}>
              <FormGroup>
                <Label>Username or email address</Label>
                <Input
                  name='login'
                  type='text'
                  value={login}
                  onFocus={this.handleFocus}
                  onChange={this.handleChange}
                />
              </FormGroup>

              <FormGroup>
                <Label>Password</Label>
                <Input
                  name='password'
                  type='password'
                  value={password}
                  onFocus={this.handleFocus}
                  onChange={this.handleChange}
                />
              </FormGroup>

              <div className='forgot-password'>
                <button type='button'>Forgot your password?</button>
              </div>

              <Button
                  className='submit'
                  type='submit'
                  size='lg'
                  block>
                Sign in to your account
              </Button>
            </Form>
          </div>
          <div className='form-flash'>
            {flash.message && <Flash />}
          </div>
          <div className='form-callout'>
            <div>
              Don't have an account? <a href='register'>Sign up</a>
            </div>
          </div>
        </div>
      </div>
    );
  }
};

function mapStateToProps(state) {
  const { flash, logged } = state;
  return { flash, logged };
}

const connectedLoginForm = connect(mapStateToProps)(LoginForm);
export { connectedLoginForm as LoginForm };
