import React, { Component } from "react";

import { Logo } from "../icons";

export class Header extends Component {
  render() {
    return (
      <header className="app-header fixed-top">
        <Logo height='24' width='24' />
      </header>
    );
  }
};
