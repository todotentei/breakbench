import React, { Component } from "react";
import { connect } from "react-redux";
import {
  Form, Button, FormGroup, Label, Input, FormFeedback, FormText
} from "reactstrap";

import { flashActions, userActions } from "../actions";
import { Logo } from "../icons";
import { Prompt } from "../components";

class RegisterForm extends Component {
  constructor(props) {
    super(props);

    this.state = {
      user: {
        username: "",
        fullname: "",
        email: "",
        password: ""
      },
      tooltipOpen: false
    };
  }

  handleFlashClose = (event) => {
    event.preventDefault();

    const { dispatch } = this.props;
    dispatch(flashActions.clear());
  }

  handleChange = (event) => {
    event.preventDefault();

    const { user } = this.state;
    const { name, value } = event.target;

    this.setState({ user: { ...user, [name]: value } });
  }

  handleSubmit = (event) => {
    event.preventDefault();

    const { user } = this.state;
    const { dispatch } = this.props;

    if (user.username && user.fullname && user.email && user.password) {
      dispatch(userActions.register(user));
    } else {
      dispatch(flashActions.error("This field is required"));
    }
  }

  render() {
    const { flash } = this.props;
    const { user } = this.state;

    return (
      <div className="container-fluid form-container">
        <div className="form-container-header"></div>
        <div className="form-container-body">
          <div className="register-form">
            <div className="form-box">
              <div className="form-logo">
                <Logo height="48" width="48" />
              </div>

              <Form onSubmit={this.handleSubmit}>
                <FormGroup>
                  <Label>Username</Label>
                  <Input
                    autoFocus
                    type="text"
                    name="username"
                    value={user.username}
                    onChange={this.handleChange}
                    placeholder="breakbench"
                  />
                  <FormText>This will be your username. </FormText>
                </FormGroup>

                <FormGroup>
                  <Label>Email address</Label>
                  <Input
                    type="email"
                    name="email"
                    value={user.email}
                    onChange={this.handleChange}
                    placeholder="email@example.com"
                  />
                  <FormText>We’ll never share your email address with anyone.</FormText>
                </FormGroup>

                <FormGroup>
                  <Label>Password</Label>
                  <Input
                    type="password"
                    name="password"
                    value={user.password}
                    onChange={this.handleChange}
                    placeholder="•••••••"
                  />
                  <FormText>Use at least one lowercase letter, one numeral, and seven characters.</FormText>
                </FormGroup>

                <Button
                    block
                    className="submit"
                    type="submit"
                    size="lg">
                  Sign up
                </Button>
              </Form>
            </div>
            <div id="flash-container">
              {flash.message &&
                <Prompt
                    className="prompt-danger"
                    onClose={this.handleFlashClose}>
                  {flash.message}
                </Prompt>
              }
            </div>
            <div className="form-callout">
              <div>
                {"Have an account? "} <a href="login">Log in</a>
              </div>
            </div>
          </div>
        </div>
        <div className="form-container-footer">
        </div>
      </div>
    );
  }
};

function mapStateToProps(state) {
  const { flash } = state;

  return { flash };
}

const connectedRegisterForm = connect(mapStateToProps)(RegisterForm);
export { connectedRegisterForm as RegisterForm };
