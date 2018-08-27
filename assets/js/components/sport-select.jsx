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
      selected_sport: null,
      sports: [],
    };
  }

  handleChange = ({value}) => {
    this.setState({ selected_sport: value });

    const { onChange } = this.props;
    if (onChange) onChange(value);
  }

  getSports = () => {
    Axios({
      method: 'post',
      url: '/api/graphiql',
      data: { query: `
        query { listSports { name } }
      `}
    })
    .then(response => {
      this.setState({
        sports: response.data.data.listSports
      });
    })
    .catch(error => {
      console.log(error);
    });
  }

  componentDidMount = () => {
    this.getSports();
  }

  render() {
    const { sports } = this.state;
    const sport_opts = sports.map(({name}) => ({
      value: name, label: name
    }));

    return (
      <div>
        <Select
          className='bb-react-select'
          classNamePrefix='bb-react-select'
          onChange={this.handleChange}
          placeholder='Select your desired sport'
          options={sport_opts}
        />
      </div>
    );
  }
};
