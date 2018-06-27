import React, { Component } from "react";
import { Router, Route } from "react-router-dom";
import { connect } from "react-redux";

import { history } from "../helpers";
import { alertActions } from "../actions";
import { PrivateRoute } from "../components";
import { HomePage, LoginPage, RegisterPage } from "./";

class WebPage extends React.Component {
  constructor(props) {
    super(props);

    const { dispatch } = this.props;
    history.listen((location, action) => {
      // Clear alert on location change
      dispatch(alertActions.clear());
    });
  }

  render() {
    const { alert } = this.props;

    return (
      <Router history={history}>
        <main id="main" role="main">
          {alert.message &&
            <div className={`alert ${alert.type}`}>
              {alert.message}
            </div>
          }
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

const connectedWebPage = connect(mapStateToProps)(WebPage);
export { connectedWebPage as WebPage };
