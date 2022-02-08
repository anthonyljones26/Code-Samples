'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.messages = exports.locale = exports.areTranslationsLoaded = undefined;

var _reactIntl = require('react-intl');

var _en = require('react-intl/locale-data/en');

var _en2 = _interopRequireDefault(_en);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

(0, _reactIntl.addLocaleData)(_en2.default);

var messages = {
  "Terra.AbstractModal.BeginModalDialog": "Begin modal dialog",
  "Terra.AbstractModal.EndModalDialog": "End modal dialog",
  "Terra.ajax.error": "This content failed to load.",
  "Terra.alert.advisory": "Advisory.",
  "Terra.alert.alert": "Alert.",
  "Terra.alert.dismiss": "Dismiss",
  "Terra.alert.error": "Error.",
  "Terra.alert.info": "Information.",
  "Terra.alert.success": "Success.",
  "Terra.alert.unsatisfied": "Required Action.",
  "Terra.alert.unverified": "Outside Records.",
  "Terra.alert.warning": "Warning.",
  "Terra.form.field.optional": "(optional)",
  "Terra.form.select.add": "Add \"{text}\"",
  "Terra.form.select.ariaLabel": "Search",
  "Terra.form.select.clearSelect": "Clear select",
  "Terra.form.select.defaultDisplay": "- Select -",
  "Terra.form.select.defaultUsageGuidance": "Use up and down arrow keys to navigate through options. Press enter to select an option.",
  "Terra.form.select.dimmed": "Dimmed.",
  "Terra.form.select.disabled": "Disabled.",
  "Terra.form.select.listOfTotalOptions": "List of {total} options.",
  "Terra.form.select.maxSelectionHelp": "Limit {text} items.",
  "Terra.form.select.maxSelectionOption": "Maximum number of {text} items selected",
  "Terra.form.select.menu": "Menu",
  "Terra.form.select.mobileButtonUsageGuidance": "Tap to navigate to options.",
  "Terra.form.select.mobileUsageGuidance": "Swipe right to navigate to options.",
  "Terra.form.select.multiSelectUsageGuidance": "Enter text or use up and down arrow keys to navigate through options. Press enter to select or unselect an option.",
  "Terra.form.select.noResults": "No matching results for \"{text}\"",
  "Terra.form.select.optGroup": "Group {text}",
  "Terra.form.select.option": "Options",
  "Terra.form.select.searchUsageGuidance": "Enter text or use up and down arrow keys to navigate through options. Press enter to select an option.",
  "Terra.form.select.selectCleared": "Select value cleared",
  "Terra.form.select.selected": "Selected.",
  "Terra.form.select.selectedText": "{text} Selected.",
  "Terra.form.select.unselected": "Unselected.",
  "Terra.form.select.unselectedText": "{text} Unselected.",
  "Terra.icon.IconConsultInstructionsForUse.title": "Electronic Instructions for Use Icon",
  "Terra.Overlay.loading": "Loading...",
  "tide.errorPage.forbidden.code": "(Error 403)",
  "tide.errorPage.forbidden.lineOne": "You are not authorized to access this page. Use your browser's Back button to return to the previous page.",
  "tide.errorPage.forbidden.title": "Unauthorized Access",
  "tide.errorPage.internalServerError.code": "(Error 500)",
  "tide.errorPage.internalServerError.lineOne": "We are sorry for the inconvenience, but we encountered an unexpected error processing your request.",
  "tide.errorPage.internalServerError.lineTwo": "Try again later or use your browser's Back button.",
  "tide.errorPage.internalServerError.title": "An Error Has Occurred",
  "tide.errorPage.notFound.code": "(Error 404)",
  "tide.errorPage.notFound.lineOne": "The page you are attempting to access does not exist.",
  "tide.errorPage.notFound.lineTwo": "Enter a different web address, or use your browser's Back button to return to the previous page.",
  "tide.errorPage.notFound.title": "Page Not Found",
  "tide.errorPage.unauthorized.code": "(Error 401)",
  "tide.errorPage.unauthorized.lineOne": "You are not authorized to access this page. Use your browser's Back button to return to the previous page.",
  "tide.errorPage.unauthorized.title": "Unauthorized Access",
  "tide.errorPage.unprocessableEntity.code": "(Error 422)",
  "tide.errorPage.unprocessableEntity.lineOne": "We are sorry for the inconvenience, but we encountered an unexpected error processing your request.",
  "tide.errorPage.unprocessableEntity.lineTwo": "Try again later or use your browser's Back button.",
  "tide.errorPage.unprocessableEntity.title": "An Error Has Occurred",
  "Tide.patientSwitcher.age": "(age {age})",
  "Tide.patientSwitcher.viewingLabel": "Viewing health record for"
};
var areTranslationsLoaded = true;
var locale = 'en-CA';
exports.areTranslationsLoaded = areTranslationsLoaded;
exports.locale = locale;
exports.messages = messages;
