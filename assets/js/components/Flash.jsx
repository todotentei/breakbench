import React, { Component } from "react";
import { connect } from "react-redux";
import ReactDOM from "react-dom";
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'

import { flashActions } from "../actions";

class Flash extends Component {
  constructor(props) {
    super(props);
  }

  onClose = (event) => {
    event.preventDefault();

    const { clear } = this.props;
    clear();
  }

  render() {
    const { flash } = this.props;

    return (
      <div className={`flash ${flash.class}`}>
        <div className="flash-body">
          {flash.message}
        </div>
        <div className="flash-close">
          <button type="button" onClick={this.onClose}>
            <FontAwesomeIcon icon="times" />
          </button>
        </div>
      </div>
    );
  }
}

function mapStateToProps(state) {
  const { flash } = state;
  return { flash };
}

function mapDispatchToProps(dispatch) {
  const clear = () => { dispatch(flashActions.clear()) }
  return { clear }
}

const connectedFlash = connect(mapStateToProps, mapDispatchToProps)(Flash);
export { connectedFlash as Flash };
