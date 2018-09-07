import Axios from 'axios';
import React, { Component } from 'react';
import PropTypes from 'prop-types';
import Select from 'react-select';

const defaultState = {
  selected_game_modes: [],
  game_modes: []
};

class SportGameModeSelect extends Component {
  constructor(props) {
    super(props);

    this.state = {...defaultState}
    this.signal = Axios.CancelToken.source();
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
    try {
      Axios({
        method: 'post',
        url: '/graphiql',
        data: { query: `
          query { listSportGameModes(sport: "${sport}") { id, name } }
        `},
        cancelToken: this.signal.token
      })
      .then(response => response.data.data.listSportGameModes)
      .then(data => {
        this.setState({
          game_modes: data.map(({id, name}) => ({value: id, label: name}))
        });
      })
      .catch(error => {
        console.log(error);
      });
    } catch (err) {
      if (axios.isCancel(err)) console.log(err.message);
    }
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

  componentWillUnmount = () => {
    this.signal.cancel('Sport\'s game mode (select) loading is being canceled');
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
