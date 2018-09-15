import React, { Component } from 'react';
import { gql } from '../utils';
import Select from 'react-select';

class SportSelect extends Component {
  constructor(props) {
    super(props);
    this.state = {
      sports: []
    };
  }

  handleChange = (selected_sport) => {
    const { onChange } = this.props;
    if (onChange) onChange(selected_sport);
  }

  loadSports = () => {
    gql.query(`{
      listSports { name }
    }`)()
      .then(data => {
        const { listSports } = data;
        const sports = listSports.map(
          ({name}) => ({ value: name, label: name })
        );

        this.setState({ sports });
      }, err => {
        console.error(err);
      });
  }

  componentDidMount = () => {
    this.loadSports();
  }

  render() {
    const { selected_sport, sports } = this.state;

    return (
      <div>
        <Select
          className='bb-react-select'
          classNamePrefix='bb-react-select'
          onChange={this.handleChange}
          placeholder='Select your desired sport'
          value={selected_sport}
          options={sports}
        />
      </div>
    );
  }
};

export default SportSelect;
