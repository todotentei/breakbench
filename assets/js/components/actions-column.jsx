import React, { Component } from 'react';
import PlayAction from './play-action';

export default class ActionsColumn extends Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div className='actions-column'>
        <div className='actions-column__play'>
          <PlayAction />
        </div>
      </div>
    );
  }
};
