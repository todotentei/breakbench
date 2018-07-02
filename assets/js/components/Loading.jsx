import React, { Component } from "react";
import _debounce from 'lodash.debounce';

export class Loading extends Component {
  constructor(props) {
    super(props);
    this.state = { status: "" }
    this.ref = React.createRef();
  }

  selfRemove = _debounce(() => {
    this.ref.current.remove();
  }, 500)

  handleLoad = () => {
    this.setState({ status: "Ready" });
    this.selfRemove();
  }

  componentDidMount = () => {
    this.setState({ status: "Loading" });
    window.addEventListener('load', this.handleLoad);
  }

  render() {
    const { status } = this.state;

    return (
      <div ref={this.ref} className="loading-overlay">
        {status && <p>{status}</p>}
      </div>
    );
  }
};
