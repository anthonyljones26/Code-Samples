'use strict';

const loadEnTranslations = (callback, scope) =>
   import( /* webpackChunkName: "en-translations" */ 'en.js')
     .then((module) => { callback.call(scope, module);})
     .catch(error => console.log('An error occurred while loading en.js' + "\n" + error));

const loadEnAUTranslations = (callback, scope) =>
   import( /* webpackChunkName: "en-AU-translations" */ 'en-AU.js')
     .then((module) => { callback.call(scope, module);})
     .catch(error => console.log('An error occurred while loading en-AU.js' + "\n" + error));

const loadEnCATranslations = (callback, scope) =>
   import( /* webpackChunkName: "en-CA-translations" */ 'en-CA.js')
     .then((module) => { callback.call(scope, module);})
     .catch(error => console.log('An error occurred while loading en-CA.js' + "\n" + error));

const loadEnUSTranslations = (callback, scope) =>
   import( /* webpackChunkName: "en-US-translations" */ 'en-US.js')
     .then((module) => { callback.call(scope, module);})
     .catch(error => console.log('An error occurred while loading en-US.js' + "\n" + error));

const loadEnGBTranslations = (callback, scope) =>
   import( /* webpackChunkName: "en-GB-translations" */ 'en-GB.js')
     .then((module) => { callback.call(scope, module);})
     .catch(error => console.log('An error occurred while loading en-GB.js' + "\n" + error));

const loadEsTranslations = (callback, scope) =>
   import( /* webpackChunkName: "es-translations" */ 'es.js')
     .then((module) => { callback.call(scope, module);})
     .catch(error => console.log('An error occurred while loading es.js' + "\n" + error));

const loadEsUSTranslations = (callback, scope) =>
   import( /* webpackChunkName: "es-US-translations" */ 'es-US.js')
     .then((module) => { callback.call(scope, module);})
     .catch(error => console.log('An error occurred while loading es-US.js' + "\n" + error));

const loadEsESTranslations = (callback, scope) =>
   import( /* webpackChunkName: "es-ES-translations" */ 'es-ES.js')
     .then((module) => { callback.call(scope, module);})
     .catch(error => console.log('An error occurred while loading es-ES.js' + "\n" + error));

const loadDeTranslations = (callback, scope) =>
   import( /* webpackChunkName: "de-translations" */ 'de.js')
     .then((module) => { callback.call(scope, module);})
     .catch(error => console.log('An error occurred while loading de.js' + "\n" + error));

const loadFrTranslations = (callback, scope) =>
   import( /* webpackChunkName: "fr-translations" */ 'fr.js')
     .then((module) => { callback.call(scope, module);})
     .catch(error => console.log('An error occurred while loading fr.js' + "\n" + error));

const loadFrFRTranslations = (callback, scope) =>
   import( /* webpackChunkName: "fr-FR-translations" */ 'fr-FR.js')
     .then((module) => { callback.call(scope, module);})
     .catch(error => console.log('An error occurred while loading fr-FR.js' + "\n" + error));

const loadNlTranslations = (callback, scope) =>
   import( /* webpackChunkName: "nl-translations" */ 'nl.js')
     .then((module) => { callback.call(scope, module);})
     .catch(error => console.log('An error occurred while loading nl.js' + "\n" + error));

const loadNlBETranslations = (callback, scope) =>
   import( /* webpackChunkName: "nl-BE-translations" */ 'nl-BE.js')
     .then((module) => { callback.call(scope, module);})
     .catch(error => console.log('An error occurred while loading nl-BE.js' + "\n" + error));

const loadPtTranslations = (callback, scope) =>
   import( /* webpackChunkName: "pt-translations" */ 'pt.js')
     .then((module) => { callback.call(scope, module);})
     .catch(error => console.log('An error occurred while loading pt.js' + "\n" + error));

const loadPtBRTranslations = (callback, scope) =>
   import( /* webpackChunkName: "pt-BR-translations" */ 'pt-BR.js')
     .then((module) => { callback.call(scope, module);})
     .catch(error => console.log('An error occurred while loading pt-BR.js' + "\n" + error));

const loadSvTranslations = (callback, scope) =>
   import( /* webpackChunkName: "sv-translations" */ 'sv.js')
     .then((module) => { callback.call(scope, module);})
     .catch(error => console.log('An error occurred while loading sv.js' + "\n" + error));

const loadSvSETranslations = (callback, scope) =>
   import( /* webpackChunkName: "sv-SE-translations" */ 'sv-SE.js')
     .then((module) => { callback.call(scope, module);})
     .catch(error => console.log('An error occurred while loading sv-SE.js' + "\n" + error));

var translationsLoaders = {
  'en': loadEnTranslations,
  'en-AU': loadEnAUTranslations,
  'en-CA': loadEnCATranslations,
  'en-US': loadEnUSTranslations,
  'en-GB': loadEnGBTranslations,
  'es': loadEsTranslations,
  'es-US': loadEsUSTranslations,
  'es-ES': loadEsESTranslations,
  'de': loadDeTranslations,
  'fr': loadFrTranslations,
  'fr-FR': loadFrFRTranslations,
  'nl': loadNlTranslations,
  'nl-BE': loadNlBETranslations,
  'pt': loadPtTranslations,
  'pt-BR': loadPtBRTranslations,
  'sv': loadSvTranslations,
  'sv-SE': loadSvSETranslations
};

module.exports = translationsLoaders;