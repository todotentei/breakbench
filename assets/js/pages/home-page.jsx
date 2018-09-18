import React, { Component } from 'react';
import { connect } from 'react-redux';
import { FindMatch } from '../components';

class HomePage extends Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div className='web-container'>
        <FindMatch />
      </div>
    );
  }
};

const mapStateToProps = (state) => ({
  authenticated: state.authenticated
});

export default connect(mapStateToProps)(HomePage);
