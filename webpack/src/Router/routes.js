import React from 'react';
import WelcomePage from './WelcomePage';

const routes = [
  {
    path: '/foreman__plugin_template/welcome',
    exact: true,
    render: (props) => <WelcomePage {...props} />,
  }
];

export default routes;
