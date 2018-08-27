import Axios from 'axios';
import React, { Component } from 'react';
import {
  Button, ButtonGroup
} from 'reactstrap';

export class TravelModeSelect extends Component {
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
    Axios({
      method: 'post',
      url: '/api/graphiql',
      data: { query: `query { listMatchmakingTravelModes { type } }`}
    })
    .then(response => {
      this.setState({
        travel_modes: response.data.data.listMatchmakingTravelModes
      });
    })
    .catch(error => {
      console.log(error);
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
