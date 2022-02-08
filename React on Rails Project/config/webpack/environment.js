const { environment } = require('@rails/webpacker')

const aggregateTranslations = require('terra-aggregate-translations');

// generate the 'aggregated-translations' in 'tmp'
aggregateTranslations({
  format: 'es6',
  outputDir: 'tmp/aggregated-translations'
});

// add the 'aggregated-translations' module to the environment
environment.resolvedModules.append('aggregated-translations', 'tmp/aggregated-translations')

module.exports = environment