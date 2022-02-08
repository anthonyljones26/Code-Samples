/* eslint-disable no-undef */
const CleanPlugin = require('clean-webpack-plugin');
const config = require('./base.config');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const path = require('path');
const webpack = require('webpack');

// find root path
const rootPath = path.join(__dirname, '../../');

// add optimize plugins normally found in the -p (production flag) in CLI
config.plugins.push(new webpack.optimize.UglifyJsPlugin({
  compress: { warnings: false }
}));
config.plugins.push(new webpack.optimize.OccurrenceOrderPlugin());

// set production NODE environment variable to remove dead code using UglifyJS
config.plugins.push(new webpack.DefinePlugin({
  'process.env': { NODE_ENV: JSON.stringify('production') }
}));

// setup long-term caching by including a hash on the end of the bundle names
config.output.filename = '[name]-[hash].js';
config.plugins.push(new ExtractTextPlugin('[name]-[hash].css'));

// clean build before running
config.plugins.push(new CleanPlugin('public/webpack', { root: rootPath }));

module.exports = config;
