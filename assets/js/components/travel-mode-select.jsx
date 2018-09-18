import React, { Component } from 'react';
import { gql } from '../utils';
import classNames from 'classnames';

class TravelModeSelect extends Component {
  constructor(props) {
    super(props);

    this.state = {
      travel_mode: '',
      travel_modes: []
    };
  }

  static defaultProps = {
    onClick: () => {}
  }

  handleClick = (e) => {
    e.preventDefault();

    const { value } = e.target
    const { onClick } = this.props;

    this.setState({ travel_mode: value })
    onClick(value);
  }

  componentDidMount = () => {
    gql.query(`{
      listMatchmakingTravelModes { type }
    }`)()
      .then(data => {
        const travel_modes = data.listMatchmakingTravelModes;
        this.setState({ travel_modes });
      }, err => {
        console.error(err);
      });
  }

  renderButton = (type, key) => {
    const { travel_mode } = this.props;

    const isActive = travel_mode == type
      ? 'web-button-active'
      : 'web-button-primary'
    const _class = classNames('web-button', isActive)

    return (
      <button key={key} value={type} className={_class} onClick={this.handleClick}>
        {type}
      </button>
    );
  }

  render() {
    const { travel_mode, travel_modes } = this.state;

    return (
      <div>
        {travel_modes.map(({type}, index) => this.renderButton(type, index))}
      </div>
    );
  }
};

export default TravelModeSelect;
