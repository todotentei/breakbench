import React from "react";

export const Logo = (props) => {
  return (
    <svg
        id="logo"
        className="logo"
        version="1.1"
        viewBox="0 0 48 48"
        {...props}>
      <polygon points="36.1,1.2 36.1,32.4 0,1.2 "/>
      <polygon points="11.9,46.8 11.9,15.6 48,46.8 "/>
    </svg>
  )
};
