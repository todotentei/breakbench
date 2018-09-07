import React, { Component } from 'react';
import classNames from 'classnames';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'

class FlashAlert extends Component {
  constructor(props) {
    super(props);
  }

  onClose = (e) => {
    e.preventDefault();

    const { onClose } = this.props;
    if (onClose) onClose();
  }

  render() {
    const { className, children } = this.props;

    return (
      <div className={classNames('flash-alert', className)}>
        <div className='flash-alert__body'>
          {children}
        </div>
        <div className='flash-alert__close'>
          <button
            type='button'
            onClick={this.onClose}
          >
            <FontAwesomeIcon icon='times' />
          </button>
        </div>
      </div>
    );
  }
};

export default FlashAlert;
