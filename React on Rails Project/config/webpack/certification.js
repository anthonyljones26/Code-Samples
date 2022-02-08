process.env.NODE_ENV = process.env.NODE_ENV || 'certification';

const environment = require('./environment');

module.exports = environment.toWebpackConfig();
