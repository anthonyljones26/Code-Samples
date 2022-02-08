'use strict';

const loadEnIntl = () =>
   import('intl/locale-data/jsonp/en.js')
   .catch(error => console.log('An error occurred while loading intl/locale-data/jsonp/en.js' + "\n" + error));

const loadEnAUIntl = () =>
   import('intl/locale-data/jsonp/en-AU.js')
   .catch(error => console.log('An error occurred while loading intl/locale-data/jsonp/en-AU.js' + "\n" + error));

const loadEnCAIntl = () =>
   import('intl/locale-data/jsonp/en-CA.js')
   .catch(error => console.log('An error occurred while loading intl/locale-data/jsonp/en-CA.js' + "\n" + error));

const loadEnUSIntl = () =>
   import('intl/locale-data/jsonp/en-US.js')
   .catch(error => console.log('An error occurred while loading intl/locale-data/jsonp/en-US.js' + "\n" + error));

const loadEnGBIntl = () =>
   import('intl/locale-data/jsonp/en-GB.js')
   .catch(error => console.log('An error occurred while loading intl/locale-data/jsonp/en-GB.js' + "\n" + error));

const loadEsIntl = () =>
   import('intl/locale-data/jsonp/es.js')
   .catch(error => console.log('An error occurred while loading intl/locale-data/jsonp/es.js' + "\n" + error));

const loadEsUSIntl = () =>
   import('intl/locale-data/jsonp/es-US.js')
   .catch(error => console.log('An error occurred while loading intl/locale-data/jsonp/es-US.js' + "\n" + error));

const loadEsESIntl = () =>
   import('intl/locale-data/jsonp/es-ES.js')
   .catch(error => console.log('An error occurred while loading intl/locale-data/jsonp/es-ES.js' + "\n" + error));

const loadDeIntl = () =>
   import('intl/locale-data/jsonp/de.js')
   .catch(error => console.log('An error occurred while loading intl/locale-data/jsonp/de.js' + "\n" + error));

const loadFrIntl = () =>
   import('intl/locale-data/jsonp/fr.js')
   .catch(error => console.log('An error occurred while loading intl/locale-data/jsonp/fr.js' + "\n" + error));

const loadFrFRIntl = () =>
   import('intl/locale-data/jsonp/fr-FR.js')
   .catch(error => console.log('An error occurred while loading intl/locale-data/jsonp/fr-FR.js' + "\n" + error));

const loadNlIntl = () =>
   import('intl/locale-data/jsonp/nl.js')
   .catch(error => console.log('An error occurred while loading intl/locale-data/jsonp/nl.js' + "\n" + error));

const loadNlBEIntl = () =>
   import('intl/locale-data/jsonp/nl-BE.js')
   .catch(error => console.log('An error occurred while loading intl/locale-data/jsonp/nl-BE.js' + "\n" + error));

const loadPtIntl = () =>
   import('intl/locale-data/jsonp/pt.js')
   .catch(error => console.log('An error occurred while loading intl/locale-data/jsonp/pt.js' + "\n" + error));

const loadPtBRIntl = () =>
   import('intl/locale-data/jsonp/pt-BR.js')
   .catch(error => console.log('An error occurred while loading intl/locale-data/jsonp/pt-BR.js' + "\n" + error));

const loadSvIntl = () =>
   import('intl/locale-data/jsonp/sv.js')
   .catch(error => console.log('An error occurred while loading intl/locale-data/jsonp/sv.js' + "\n" + error));

const loadSvSEIntl = () =>
   import('intl/locale-data/jsonp/sv-SE.js')
   .catch(error => console.log('An error occurred while loading intl/locale-data/jsonp/sv-SE.js' + "\n" + error));

var intlLoaders = {
  'en': loadEnIntl,
  'en-AU': loadEnAUIntl,
  'en-CA': loadEnCAIntl,
  'en-US': loadEnUSIntl,
  'en-GB': loadEnGBIntl,
  'es': loadEsIntl,
  'es-US': loadEsUSIntl,
  'es-ES': loadEsESIntl,
  'de': loadDeIntl,
  'fr': loadFrIntl,
  'fr-FR': loadFrFRIntl,
  'nl': loadNlIntl,
  'nl-BE': loadNlBEIntl,
  'pt': loadPtIntl,
  'pt-BR': loadPtBRIntl,
  'sv': loadSvIntl,
  'sv-SE': loadSvSEIntl
};

module.exports = intlLoaders;