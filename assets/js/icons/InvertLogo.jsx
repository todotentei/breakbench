import React from "react";

export const InvertLogo = (props) => {
  return (
    <svg
        id="logo"
        className={`logo ${props.styleName}`}
        version="1.1"
        viewBox="0 0 48 48"
        {...props}>
      <path d="M0,0v48h48V0H0z M34.6,37H20.4h-7l7-6.1V18.6l14.2,12.3C34.6,32.9,34.6,35.1,34.6,37z M34.6,29.4L13.4,11h21.2V29.4z"/>
    </svg>
  )
};
