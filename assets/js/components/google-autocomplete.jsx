import React, { Component } from 'react';
import ReactDOM from 'react-dom';
import { Input } from 'reactstrap';
import PlacesAutocomplete from 'react-places-autocomplete';

class GoogleAutocomplete extends Component {
  constructor(props) {
    super(props);
    this.state = {
      address: ''
    };
  }

  handleChange = (address) => {
    this.setState({ address });

    const { onClick } = this.props;
    if (onClick) onClick(address);
  }

  handleSelect = (address) => {
    this.setState({ address });

    const { onSelect } = this.props;
    if (onSelect) onSelect(address);
  }

  render() {
    return (
      <PlacesAutocomplete
        value={this.state.address}
        onChange={this.handleChange}
        onSelect={this.handleSelect}
      >
        {({ getInputProps, suggestions, getSuggestionItemProps }) => (
          <div>
            <Input
              {...getInputProps({
                name: 'location',
                placeholder: 'Your current location',
                className: 'play-info-location'
              })}
            />
            <div className="autocomplete-dropdown-container">
              {suggestions.map(suggestion => {
                const className = suggestion.active
                  ? 'suggestion-item--active'
                  : 'suggestion-item';
                return (
                  <div {...getSuggestionItemProps(suggestion, { className })}>
                    <span>{suggestion.description}</span>
                  </div>
                );
              })}
            </div>
          </div>
        )}
      </PlacesAutocomplete>
    );
  }
};

export default GoogleAutocomplete;
