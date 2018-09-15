import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import {
  flashAlertActions,
  sessionActions
} from '../actions';
import { FlashAlert } from '../components';
import { LoginForm } from '../forms';
import history from '../utils/history';

class LoginPage extends Component {
  constructor(props) {
    super(props);

    this.state = {
      user: {
        username_or_email: '',
        password: '',
        remember_me: true
      }
    };
  }

  handleChange = (obj) => {
    const { name, value } = obj;
    const { user } = this.state;

    user[name] = value;
    this.setState({ user });
  }

  handleSubmit = (e) => {
    console.log(e);

    // login(user);
  }

  componentDidUpdate = () => {
    const { authenticated } = this.props;
    if (authenticated) history.push('/');
  }

  render() {
    const { clearAlert, flashAlert } = this.props;

    return (
      <div className='login-page'>
        {flashAlert.message &&
          <FlashAlert
            className={flashAlert.type}
            onClose={clearAlert}
          >
            <div>{flashAlert.message}</div>
          </FlashAlert>
        }
        <LoginForm
          onChange={this.handleChange}
          onSubmit={this.handleSubmit}
        />
      </div>
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
