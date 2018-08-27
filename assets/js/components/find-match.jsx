import React, { Component } from 'react';
import {
  Button,
  Form,
  FormGroup,
  Label
} from 'reactstrap';
import {
  geocodeByAddress,
  getLatLng
} from 'react-places-autocomplete';
import {
  GoogleAutocomplete,
  SportGameModeSelect,
  SportSelect,
  TravelModeSelect
} from './';

export class FindMatch extends Component {
  constructor(props) {
    super(props);

    this.state = {
      location: null,
      travel_mode: null,
      sport: null,
      game_modes: []
    }
  }

  handleGACClick = (address) => {
    if (!address) this.setState({ location: null });
  }

  handleGAGSelect = (address) => {
    geocodeByAddress(address)
      .then(results => getLatLng(results[0]))
      .then(location => this.setState({ location }))
      .catch(error => this.setState({ location: null }));
  }

  handleTVMClick = (travel_mode) => {
    this.setState({ travel_mode });
  }

  handleSPSChange = (sport) => {
    this.setState({ sport });
  }

  handleSGMChange = (game_modes) => {
    this.setState({ game_modes });
  }

  handleFindMatch = (e) => {
    e.preventDefault();
    console.log(this.state);
  }

  renderSGMSelect = (sport) => {
    if (sport)
      return (
        <FormGroup className='bb-find-match__game-mode'>
          <Label>Game modes</Label>
          <SportGameModeSelect
            sport={sport}
            onChange={this.handleSGMChange}
          />
        </FormGroup>
      );
  }

  render() {
    const { sport } = this.state;

    return (
      <Form className='bb-find-match'>
        <FormGroup className='bb-find-match__location'>
          <Label>Location</Label>
          <GoogleAutocomplete
            onChange={this.handleGACClick}
            onSelect={this.handleGAGSelect}
          />
        </FormGroup>
        <FormGroup className='bb-find-match__travel-mode'>
          <Label>Travel mode</Label>
          <TravelModeSelect
            onClick={this.handleTVMClick}
          />
        </FormGroup>
        <FormGroup className='bb-find-match__sport'>
          <Label>Sport</Label>
          <SportSelect
            onChange={this.handleSPSChange}
          />
        </FormGroup>
        {this.renderSGMSelect(sport)}
        <Button
          size='lg'
          onClick={this.handleFindMatch}
          className='bb-find-match__submit'
          outline
        >
          Find Match
        </Button>
      </Form>
    );
  }
};
