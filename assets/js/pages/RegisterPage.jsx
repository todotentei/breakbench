import React, { Component } from "react";

import { Logo } from "../icons";
import { RegisterForm } from "../forms";

export class RegisterPage extends Component {
  render() {
    return (
      <div className="register-page">
        <RegisterForm />
      </div>
    );
  }
};
