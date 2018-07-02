import React, { Component } from "react";
import { Router, Route } from "react-router-dom";
import { connect } from "react-redux";

import { history } from "../helpers";
import { alertActions, flashActions } from "../actions";
import { HomePage, LoginPage, RegisterPage } from "../pages";
import { Loading } from "./";

class Content extends Component {
  constructor(props) {
    super(props);

    const { dispatch } = this.props;
    history.listen((location, action) => {
      // Clear alert on location change
      dispatch(alertActions.clear());
      dispatch(flashActions.clear());
    });
  }

  render() {
    const { alert } = this.props;

    return (
      <Router history={history}>
        <main id="main" role="main" className="app-content">
          {alert.message &&
            <div className={`alert ${alert.type}`}>
              {alert.message}
            </div>
          }
          <Loading />
          <Route exact path="/" component={HomePage} />
          <Route exact path="/login" component={LoginPage} />
          <Route exact path="/register" component={RegisterPage} />
        </main>
      </Router>
    );
  }
}

function mapStateToProps(state) {
  const { alert } = state;
  return { alert };
}

const connectedContent = connect(mapStateToProps)(Content);
export { connectedContent as Content };
