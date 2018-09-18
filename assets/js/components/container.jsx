import React from 'react';
import classNames from 'classnames';

const defaultClass = 'web-container'

const Container = (props) => {
  const { className } = props;
  const _class = classNames(defaultClass, className);

  return (
    <div {...props} className={_class} />
  );
};

export default Container;
