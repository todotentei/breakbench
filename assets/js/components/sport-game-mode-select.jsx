import React, { Component } from 'react';
import { gql } from '../utils';
import PropTypes from 'prop-types';
import Select from 'react-select';

const defaultState = {
  selected_game_modes: [],
  game_modes: []
};

class SportGameModeSelect extends Component {
  constructor(props) {
    super(props);

    this.state = {
      ...defaultState
    };
  }

  resetState = () => {
    this.setState({...defaultState});
  }

  handleChange = (selected_game_modes) => {
    this.setState({ selected_game_modes });

    const { onChange } = this.props;
    if (onChange) onChange(selected_game_modes);
  }

  loadGameModes = (sport) => {
    gql.query(`($sport: String!) {
      listGameModes( sport: $sport ) {
        id,
        name
      }
    }`, {
      sport: sport
    }).then(data => {
      const { listGameModes } = data;
      const game_modes = listGameModes.map(
        ({id, name}) => ({ value: id, label: name })
      );

      this.setState({ game_modes });
    }, err => {
      console.error(err);
    });
  }

  componentWillMount = () => {
    const { sport } = this.props;
    this.loadGameModes(sport)
  }

  componentWillReceiveProps = (nextProps) => {
    const { sport } = nextProps;

    if (sport != this.props.sport) {
      this.resetState();
      if (sport) this.loadGameModes(sport);
    }
  }

  render() {
    const { selected_game_modes, game_modes } = this.state;

    return (
      <Select
        isMulti
        closeMenuOnSelect={false}
        className='bb-react-select'
        classNamePrefix='bb-react-select'
        onChange={this.handleChange}
        placeholder='Choose your game modes'
        value={selected_game_modes}
        options={game_modes}
      />
    );
  }
}

SportGameModeSelect.propTypes = {
  sport: PropTypes.string
};

export default SportGameModeSelect;
