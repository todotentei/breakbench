import React, { Component } from 'react';
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

export default class FindMatch extends Component {
  constructor(props) {
    super(props);

    this.state = {
      location: null,
      travel_mode: null,
      availability_mode: 'normal',
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
    this.setState({
      sport: sport['value']
    });
  }

  handleSGMChange = (game_modes) => {
    this.setState({
      game_modes: game_modes.map(obj => obj['value'])
    });
  }

  handleFindMatch = (e) => {
    e.preventDefault();

    const { onSubmit } = this.props;
    if (onSubmit) onSubmit(this.state)
  }

  renderSGMSelect = () => {
    const { sport } = this.state;

    if (sport)
      return (
        <div className='web-form-group'>
          <Label>Game modes</Label>
          <SportGameModeSelect
            sport={sport}
            onChange={this.handleSGMChange}
          />
        </div>
      );
  }

  render() {
    return (
      <form className='bb-find-match'>
        <div className='web-form-group'>
          <label>Location</label>
          <GoogleAutocomplete
            onChange={this.handleGACClick}
            onSelect={this.handleGAGSelect}
          />
        </div>
        <div className='web-form-group'>
          <label>Travel mode</label>
          <TravelModeSelect onClick={this.handleTVMClick} />
        </div>
        <div className='web-form-group'>
          <label>Sport</label>
          <SportSelect onChange={this.handleSPSChange} />
        </div>
        {this.renderSGMSelect()}
        <button
          onClick={this.handleFindMatch}
          className='web-button web-button-primary'
        >
          Find Match
        </button>
      </form>
    );
  }
};
