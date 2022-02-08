process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')
const myCssLoaderOptions = {
  localIdentName: '[name]__[local]___[hash:base64:10]',
};
const CSSLoader = environment.loaders.get('moduleSass').use.find((el) => el.loader === 'css-loader');
CSSLoader.options = {...CSSLoader.options, ...myCssLoaderOptions};

module.exports = environment.toWebpackConfig()
