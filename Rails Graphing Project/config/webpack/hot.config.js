/* eslint-disable no-undef */
const config = require('./base.config');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const webpack = require('webpack');

const devServerPort = 3808; // needs to match a forwarded_port in your Vagrantfile
const railsServerPort = 3000; // needs to match a forwarded_port in your Vagrantfile

// add webpack dev server with hot module replacement
config.entry.main.unshift('webpack/hot/only-dev-server');

config.plugins.push(new webpack.NoEmitOnErrorsPlugin());
config.plugins.push(new webpack.HotModuleReplacementPlugin());
config.plugins.push(new webpack.NamedModulesPlugin());
config.plugins.push(new ExtractTextPlugin({ disable: true }));

config.devtool = 'inline-source-map';
config.output.pathinfo = true;

// setup webpack dev server to host the file where Rails would have put it
config.output.publicPath = 'http://localhost:' + devServerPort + '/webpack/';

// configure dev server
config.devServer = {
  hot: true,
  // public: '10.0.2.2', // uncomment when testing on another VM (for IE10) with this IP
  publicPath: '/webpack/',
  host: '0.0.0.0', // use '0.0.0.0' binding on vagrant, otherwise use 'localhost'
  port: devServerPort,
  headers: {
    'Access-Control-Allow-Origin': 'http://localhost:' + railsServerPort,
    'Access-Control-Allow-Credentials': 'true',
  },
  watchOptions: {
    poll: 1000,
    ignored: '/node_modules/'
  }
};

module.exports = config;
