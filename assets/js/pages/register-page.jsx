import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import {
  flashAlertActions,
  userActions
} from '../actions';
import { FlashAlert } from '../components';
import { RegisterForm } from '../forms';

class RegisterPage extends Component {
  constructor(props) {
    super(props);
  }

  handleSubmit = (e) => {
    console.log(e);
    // register(user);
  }

  componentWillMount = () => {
    const { redirectOnAuth } = this.props;
    redirectOnAuth();
  }

  componentWillUpdate = () => {
    const { redirectOnAuth } = this.props;
    redirectOnAuth();
  }

  render() {
    const { clearAlert, flashAlert } = this.props;

    return (
      <div className='register-page'>
        {flashAlert.message &&
          <FlashAlert
            className={flashAlert.type}
            onClose={clearAlert}
          >
            <div>{flashAlert.message}</div>
          </FlashAlert>
        }
        <RegisterForm
          onSubmit={this.handleSubmit}
        />
      </div>
    );
  }
};

const mapStateToProps = (state) => {
  const {
    authenticated,
    flashAlert
  } = state;

  const redirectOnAuth = () => {
    if (authenticated) history.push('/');
  };

  return {
    flashAlert,
    redirectOnAuth
  };
};

const mapDispatchToProps = (dispatch) => {
  const { clear } = flashAlertActions;
  const { register } = userActions;

  return {
    clearAlert: bindActionCreators(clear, dispatch),
    register: bindActionCreators(register, dispatch)
  };
};

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(RegisterPage);
