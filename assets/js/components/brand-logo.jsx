import React, { Component } from 'react';
import PropTypes from 'prop-types';
import classNames from 'classnames';

export default class BrandLogo extends Component {
  constructor(props) {
    super(props);
  }

  render() {
    const { className, height, width } = this.props;

    return (
      <svg
        id="logo"
        className={classNames('logo', className)}
        version="1.1"
        viewBox="0 0 48 48"
        height={height}
        width={width}
      >
        <polygon points="43.6,0 43.6,33.9 4.4,0 " />
        <path d="M17.4,14.1v22.7L4.4,48h13h26.2c0-3.5,0-7.6,0-11.2L17.4,14.1z" />
      </svg>
    );
  }
};

BrandLogo.propTypes = {
  height: PropTypes.string.isRequired,
  width: PropTypes.string.isRequired
};
