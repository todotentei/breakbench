import Axios from 'axios';
import React, { Component } from 'react';
import {
  FormGroup,
  Label
} from 'reactstrap';
import Select from 'react-select';

export class SportSelect extends Component {
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
    Axios({
      method: 'post',
      url: '/api/graphiql',
      data: { query: `
        query { listSports { name } }
      `}
    })
    .then(response => response.data.data.listSports)
    .then(data => {
      this.setState({
        sports: data.map(({name}) => ({ value: name, label: name }))
      });
    })
    .catch(error => {
      console.log(error);
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
