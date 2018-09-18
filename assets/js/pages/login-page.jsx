import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import {
  flashAlertActions,
  sessionActions
} from '../actions';
import { Container, FlashAlert, Logo } from '../components';
import { LoginForm } from '../forms';
import history from '../utils/history';

const logoColor = { top: '#fff', bottom: '#fff' };

class LoginPage extends Component {
  constructor(props) {
    super(props);
  }

  handleSubmit = (user) => {
    const { login } = this.props;
    login(user);
  }

  componentDidUpdate = () => {
    const { authenticated } = this.props;
    if (authenticated) history.push('/');
  }

  renderFlashAlert = () => {
    const { clearAlert } = this.props;
    const { type, message } = this.props.flashAlert;

    return (
      message &&
        <FlashAlert className={type} onClose={clearAlert}>
          <div>{message}</div>
        </FlashAlert>
    );
  }

  render() {
    return (
      <Container className='login-page'>
        <div className='login-page__header'>
          <div className='login-page__header__logo'>
            <Logo width='20px' height='20px' fill={logoColor} />
          </div>
          <span className='login-page__header__text'>
            Log into Breakbench
          </span>
        </div>
        {this.renderFlashAlert()}
        <div className='login-page__login-form'>
          <LoginForm
            onChange={this.handleChange}
            onSubmit={this.handleSubmit}
          />
        </div>
      </Container>
    );
  }
};

const mapStateToProps = (state) => ({
  flashAlert: state.flashAlert,
  authenticated: state.authenticated
});

const mapDispatchToProps = (dispatch) => {
  const { clear } = flashAlertActions;
  const { login } = sessionActions;

  return {
    clearAlert: bindActionCreators(clear, dispatch),
    login: bindActionCreators(login, dispatch)
  };
};

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(LoginPage);
