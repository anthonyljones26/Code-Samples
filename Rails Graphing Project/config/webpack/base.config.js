/* eslint-disable no-undef */
const autoprefixer = require('autoprefixer');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const path = require('path');
const StatsPlugin = require('stats-webpack-plugin');
const webpack = require('webpack');

// find root path
const rootPath = path.join(__dirname, '../../');

// find scss path from each module in package.json dependencies
const modulePaths = Object.keys(require(path.join(rootPath, 'package.json')).dependencies)
  .reduce((paths, module) => {
    let includePaths;

    try {
      if (module === 'c3') {
        includePaths = path.join(rootPath, 'node_modules', 'c3');
      } else {
        includePaths = require(module).includePaths;
      }
    } catch (err) {
      includePaths = undefined;
    }

    return (includePaths === undefined) ? paths : paths.concat(includePaths);
  }, []);

module.exports = {
  // directory to find entry point
  context: path.join(rootPath, 'app', 'assets'),

  // build source maps
  devtool: 'source-map',

  // define entry point
  entry: {
    main: ['./javascripts/main'],
    vendor: ['./javascripts/vendor'],
    timekeeper: ['./javascripts/timekeeper']
  },

  // define output directory and filename
  output: {
    filename: '[name].js',
    path: path.join(rootPath, 'public', 'webpack')
  },

  plugins: [
    // use code splitting to move vendor includes to own file
    new webpack.optimize.CommonsChunkPlugin({
      name: 'vendor'
    }),

    // asset manifest is created for the webpack-rails gem
    new StatsPlugin('manifest.json', {
      chunkModules: false,
      source: false,
      chunks: false,
      modules: false,
      assets: true
    }),

    // add vendor prefixes to css
    new webpack.LoaderOptionsPlugin({
      options: {
        postcss: [
          autoprefixer()
        ]
      }
    })
  ],

  module: {
    rules: [
      // js extentions, transpiled with babel
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: [
          {
            loader: 'babel-loader',
            options: { presets: ['env'] }
          }
        ]
      },

      // scss/css extentions, autoprefixed, extracted into css
      {
        test: /\.(scss|css)$/,
        use: ExtractTextPlugin.extract({
          fallback: 'style-loader',
          use: [
            {
              loader: 'css-loader',
              options: {
                sourceMap: true,
                importLoaders: 2,
                minimize: true
              }
            },
            'postcss-loader',
            {
              loader: 'sass-loader',
              options: {
                sourceMap: true,
                includePaths: modulePaths
              }
            }
          ]
        })
      },

      // image extentions, copied or inline files if smaller than limit
      {
        test: /\.(png|jpg|gif|svg|eot|ttf|woff|woff2)$/,
        use: [
          {
            loader: 'url-loader',
            options: { limit: 10000 }
          }
        ]
      }
    ]
  }
};
