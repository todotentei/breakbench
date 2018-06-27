import React, { Component } from "react";

import { Logo } from "../icons";
import { RegisterForm } from "../forms";

export class RegisterPage extends Component {
  render() {
    return (
      <div className="container-fluid register-page">
        <div className="row">
          <div className="col rp-info-col">
            <Logo />
            <div>
              <h1>Feel alive.</h1>
            </div>
          </div>
          <div className="col rp-form-col">
            <RegisterForm />
          </div>
        </div>
      </div>
    );
  }
};
