import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { Router } from 'react-router-dom';
import { flashAlertActions } from './actions';
import routes from './routes';
import history from './utils/history';

class Breakbench extends Component {
  constructor(props) {
    super(props);

    const { clearAlert } = this.props;
    history.listen((location, action) => {
      // clear alert on location change
      clearAlert();
    });
  }

  render() {
    return (
      <Router
        history={history}
        children={routes}
      />
    );
  }
};

const mapDispatchToProps = (dispatch) => ({
  clearAlert: bindActionCreators(flashAlertActions.clear, dispatch)
});

export default connect(null, mapDispatchToProps)(Breakbench);
