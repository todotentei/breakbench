import React, { Component } from 'react';
import { gql } from '../utils';
import {
  Button, ButtonGroup
} from 'reactstrap';

class TravelModeSelect extends Component {
  constructor(props) {
    super(props);

    this.state = {
      travel_mode: null,
      travel_modes: []
    };
  }

  handleClick = (e) => {
    e.preventDefault();

    const { value } = e.target
    this.setState({ travel_mode: value })

    const { onClick } = this.props;
    if (onClick) onClick(value);
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

  render() {
    const { travel_mode, travel_modes } = this.state;

    return (
      <div>
        <ButtonGroup>
          {travel_modes.map(({type}, index) =>
            <Button
              key={ index }
              value={type}
              onClick={this.handleClick}
              active={travel_mode === type}
            >
              {type}
            </Button>
          )}
        </ButtonGroup>
      </div>
    );
  }
};

export default TravelModeSelect;
