import React from "react";

export const Logo = (props) => {
  return (
    <svg
        id="logo"
        className={`logo ${props.styleName}`}
        version="1.1"
        viewBox="0 0 48 48"
        {...props}>
      <polygon points="43.6,0 43.6,33.9 4.4,0 " />
      <path d="M17.4,14.1v22.7L4.4,48h13h26.2c0-3.5,0-7.6,0-11.2L17.4,14.1z" />
    </svg>
  )
};
