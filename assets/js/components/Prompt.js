import React, { Component } from "react";
import ReactDOM from "react-dom";
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'

export class Prompt extends Component {
  constructor(props) {
    super(props);
    this.myRef = React.createRef();
  }

  render() {
    return (
      <div ref={this.myRef} className={`prompt ${this.props.className}`}>
        <div className="prompt-body">
          {this.props.children}
        </div>
        <div className="prompt-close">
          <button type="button" onClick={this.props.onClose}>
            <FontAwesomeIcon icon="times" />
          </button>
        </div>
      </div>
    );
  }
};
