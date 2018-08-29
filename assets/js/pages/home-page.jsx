import React, { Component } from "react";

import {
  ActionsColumn,
  HeaderBar
} from '../components';

export class HomePage extends Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div className="home-page">
        <div className='home-page__nav-bar'>
          <HeaderBar />
        </div>
        <div className='home-page__body'>
        </div>
        <div className='home-page__actions'>
          <ActionsColumn />
        </div>
      </div>
    );
  }
};
