import React, { Component } from "react";
import { BrandLogo } from './';

export class HeaderBar extends Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div className='header-bar'>
        <BrandLogo height='24' width='24'/>
      </div>
    );
  }
};
