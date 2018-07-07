import { library } from '../node_modules/@fortawesome/fontawesome-svg-core';
import { faTimes } from '../node_modules/@fortawesome/free-solid-svg-icons';
library.add(faTimes)


import "../scss/app.scss";

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

import React from "react";
import ReactDOM from "react-dom";
import { Provider } from "react-redux";

import { store } from "./helpers";
import { Header, Content, Footer } from "./components";

ReactDOM.render((
  <Provider store={store}>
    <div>
      <Header />
      <Content />
      <Footer />
    </div>
  </Provider>
), document.getElementById("breakbench-app"))