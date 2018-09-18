import React, { Component } from 'react';
import { string } from 'prop-types';
import classNames from 'classnames';

const topSide = '43.6,0 43.6,33.9 4.4,0';
const botSide = 'M17.4,14.1v22.7L4.4,48h13h26.2c0-3.5,0-7.6,0-11.2L17.4,14.1z';

class Logo extends Component {
  constructor(props) {
    super(props);
  }

  static defaultProps = {
    style: {},
    viewBox: '0 0 48 48',
    className: '',
    fill: { top: '#000', bottom: '#000' }
  }

  static propTypes = {
    height: string.isRequired,
    width: string.isRequired
  };


  render() {
    const { fill, ...props } = this.props;

    return (
      <div>
        <svg version='1.1' {...props}>
          <polygon points={topSide} fill={fill.top} />
          <path d={botSide} fill={fill.bottom} />
        </svg>
      </div>
    );
  }
};

export default Logo;
