import Axios from 'axios';
import React, { Component } from 'react';
import PropTypes from 'prop-types';
import Select from 'react-select';

export class SportGameModeSelect extends Component {
  constructor(props) {
    super(props);

    this.state = {
      selected_game_modes: [],
      game_modes: []
    }
  }

  handleChange = (selected_game_modes) => {
    this.setState({ selected_game_modes });

    const { onChange } = this.props;
    if (onChange) onChange(selected_game_modes);
  }

  getGameModes = (sport) => {
    Axios({
      method: 'post',
      url: '/api/graphiql',
      data: { query: `
        query { listSportGameModes(sport: "${sport}") { name } }
      `}
    })
    .then(response => {
      this.setState({
        game_modes: response.data.data.listSportGameModes
      });
    })
    .catch(error => {
      console.log(error);
    });
  }

  componentDidMount = () => {
    const { sport } = this.props;
    this.getGameModes(sport)
  }

  componentWillReceiveProps = (nextProps) => {
    const { sport } = nextProps;
    if (sport) this.getGameModes(sport)
  }

  render() {
    const { game_modes } = this.state;

    const game_mode_opts = game_modes.map(({name}) => ({
      value: name, label: name
    }));

    return (
      <Select
        isMulti
        closeMenuOnSelect={false}
        className='bb-react-select'
        classNamePrefix='bb-react-select'
        onChange={this.handleChange}
        placeholder='Choose your game modes'
        options={game_mode_opts}
      />
    );
  }
}

SportGameModeSelect.propTypes = {
  sport: PropTypes.string
};
