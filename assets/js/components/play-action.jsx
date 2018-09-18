import React, { Component } from 'react';
import ReactModal from 'react-modal';
import socket from '../socket'
import FindMatch from './find-match';

ReactModal.setAppElement('#breakbench-app');

export default class PlayAction extends Component {
  constructor(props) {
    super(props);

    this.state = {
      triggeredPlay: false
    };

    socket.connect();
    this.channel = socket.channel("matchmaking:new", {});
  }

  handleOpenPlayForm = () => {
    this.setState({ triggeredPlay: true });
  }

  handleClosePlayForm = () => {
    this.setState({ triggeredPlay: false });
  }

  handleFindMatch = (attrs) => {
    this.channel.push("CREATED_QUEUE", attrs)
      .receive("ok", resp => {
        console.log("Pushed successfully", resp)
      });
  }

  componentWillMount = () => {
    this.channel.join()
      .receive("ok", resp => {
        console.log("Joined successfully", resp)
      });

    this.channel.on("CREATED_QUEUE", (resp) => {
      console.log(resp);
    })
  }

  componentWillUnmount = () => {
    this.channel.leave();
  }

  render() {
    const { triggeredPlay } = this.state;

    return (
      <div>
        <button
          type='button'
          className='web-button web-button-primary'
          onClick={this.handleOpenPlayForm}
        >
          play
        </button>
        <ReactModal
          portalClassName='bb-react-modal__find-match'
          className='bb-react-modal__find-match--content'
          overlayClassName='bb-react-modal__find-match--overlay'
          contentLabel='Minimal Modal Example'
          onRequestClose={this.handleClosePlayForm}
          shouldCloseOnOverlayClick={true}
          isOpen={triggeredPlay}
        >
          <FindMatch onSubmit={this.handleFindMatch} />
        </ReactModal>
      </div>
    );
  }
};
