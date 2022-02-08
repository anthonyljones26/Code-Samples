webpackJsonp([16],{

/***/ 931:
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.messages = exports.locale = exports.areTranslationsLoaded = undefined;

var _reactIntl = __webpack_require__(6);

var _de = __webpack_require__(946);

var _de2 = _interopRequireDefault(_de);

function _interopRequireDefault(obj) {
  return obj && obj.__esModule ? obj : { default: obj };
}

(0, _reactIntl.addLocaleData)(_de2.default);

var messages = {
  "Terra.AbstractModal.BeginModalDialog": "Modaldialog starten",
  "Terra.AbstractModal.EndModalDialog": "Beenden Sie den modalen Dialog",
  "Terra.ajax.error": "Inhalt konnte nicht geladen werden.",
  "Terra.alert.advisory": "Hinweis.",
  "Terra.alert.alert": "Warnung.",
  "Terra.alert.dismiss": "Verwerfen",
  "Terra.alert.error": "Fehler.",
  "Terra.alert.info": "Informationen.",
  "Terra.alert.success": "Erfolg.",
  "Terra.alert.unsatisfied": "Erforderliche Aktion.",
  "Terra.alert.unverified": "Externe Datensätze",
  "Terra.alert.warning": "Achtung.",
  "Terra.form.field.optional": "(wahlweise)",
  "Terra.form.select.add": "\"{text}\" hinzufügen",
  "Terra.form.select.ariaLabel": "Suchen",
  "Terra.form.select.clearSelect": "Ausgewählte entfernen",
  "Terra.form.select.defaultDisplay": "- Auswählen -",
  "Terra.form.select.defaultUsageGuidance": "Verwenden Sie die Pfeiltasten, um durch die Optionen zu navigieren. Drücken Sie die Eingabetaste, um eine Option auszuwählen.",
  "Terra.form.select.dimmed": "Gedimmt",
  "Terra.form.select.disabled": "Deaktiviert",
  "Terra.form.select.listOfTotalOptions": "Liste von {total} Optionen",
  "Terra.form.select.maxSelectionHelp": "{text} Elemente begrenzen.",
  "Terra.form.select.maxSelectionOption": "Maximale Anzahl an ausgewählten {text} Elementen",
  "Terra.form.select.menu": "Menü",
  "Terra.form.select.mobileButtonUsageGuidance": "Klicken, um zu Optionen zu navigieren",
  "Terra.form.select.mobileUsageGuidance": "Nach rechts wischen, um zu Optionen zu navigieren",
  "Terra.form.select.multiSelectUsageGuidance": "Geben Sie Text ein oder verwenden Sie die Pfeiltasten, um durch die Optionen zu navigieren. Drücken Sie die Eingabetaste, um eine Option auszuwählen oder die Auswahl aufzuheben.",
  "Terra.form.select.noResults": "Keine Übereinstimmungen für \"{text}\"",
  "Terra.form.select.optGroup": "Gruppe {text}",
  "Terra.form.select.option": "Optionen",
  "Terra.form.select.searchUsageGuidance": "Geben Sie Text ein oder verwenden Sie die Pfeiltasten, um durch die Optionen zu navigieren. Drücken Sie die Eingabetaste, um eine Option auszuwählen.",
  "Terra.form.select.selectCleared": "Ausgewählter Wert wurde entfernt",
  "Terra.form.select.selected": "Ausgewählt",
  "Terra.form.select.selectedText": "Ausgewählt: {text}",
  "Terra.form.select.unselected": "Nicht ausgewählt",
  "Terra.form.select.unselectedText": "{text} nicht ausgewählt",
  "Terra.icon.IconConsultInstructionsForUse.title": "Symbol 'Elektronische Gebrauchsanweisung'",
  "Terra.Overlay.loading": "Ladevorgang..."
};
var areTranslationsLoaded = true;
var locale = 'de';
exports.areTranslationsLoaded = areTranslationsLoaded;
exports.locale = locale;
exports.messages = messages;

/***/ }),

/***/ 946:
/***/ (function(module, exports, __webpack_require__) {

!function(e,t){ true?module.exports=t():"function"==typeof define&&define.amd?define(t):(e.ReactIntlLocaleData=e.ReactIntlLocaleData||{},e.ReactIntlLocaleData.de=t())}(this,function(){"use strict";return[{locale:"de",pluralRuleFunction:function(e,t){var n=!String(e).split(".")[1];return t?"other":1==e&&n?"one":"other"},fields:{year:{displayName:"Jahr",relative:{0:"dieses Jahr",1:"nächstes Jahr","-1":"letztes Jahr"},relativeTime:{future:{one:"in {0} Jahr",other:"in {0} Jahren"},past:{one:"vor {0} Jahr",other:"vor {0} Jahren"}}},"year-short":{displayName:"Jahr",relative:{0:"dieses Jahr",1:"nächstes Jahr","-1":"letztes Jahr"},relativeTime:{future:{one:"in {0} Jahr",other:"in {0} Jahren"},past:{one:"vor {0} Jahr",other:"vor {0} Jahren"}}},month:{displayName:"Monat",relative:{0:"diesen Monat",1:"nächsten Monat","-1":"letzten Monat"},relativeTime:{future:{one:"in {0} Monat",other:"in {0} Monaten"},past:{one:"vor {0} Monat",other:"vor {0} Monaten"}}},"month-short":{displayName:"Monat",relative:{0:"diesen Monat",1:"nächsten Monat","-1":"letzten Monat"},relativeTime:{future:{one:"in {0} Monat",other:"in {0} Monaten"},past:{one:"vor {0} Monat",other:"vor {0} Monaten"}}},day:{displayName:"Tag",relative:{0:"heute",1:"morgen",2:"übermorgen","-2":"vorgestern","-1":"gestern"},relativeTime:{future:{one:"in {0} Tag",other:"in {0} Tagen"},past:{one:"vor {0} Tag",other:"vor {0} Tagen"}}},"day-short":{displayName:"Tag",relative:{0:"heute",1:"morgen",2:"übermorgen","-2":"vorgestern","-1":"gestern"},relativeTime:{future:{one:"in {0} Tag",other:"in {0} Tagen"},past:{one:"vor {0} Tag",other:"vor {0} Tagen"}}},hour:{displayName:"Stunde",relative:{0:"in dieser Stunde"},relativeTime:{future:{one:"in {0} Stunde",other:"in {0} Stunden"},past:{one:"vor {0} Stunde",other:"vor {0} Stunden"}}},"hour-short":{displayName:"Std.",relative:{0:"in dieser Stunde"},relativeTime:{future:{one:"in {0} Std.",other:"in {0} Std."},past:{one:"vor {0} Std.",other:"vor {0} Std."}}},minute:{displayName:"Minute",relative:{0:"in dieser Minute"},relativeTime:{future:{one:"in {0} Minute",other:"in {0} Minuten"},past:{one:"vor {0} Minute",other:"vor {0} Minuten"}}},"minute-short":{displayName:"Min.",relative:{0:"in dieser Minute"},relativeTime:{future:{one:"in {0} Min.",other:"in {0} Min."},past:{one:"vor {0} Min.",other:"vor {0} Min."}}},second:{displayName:"Sekunde",relative:{0:"jetzt"},relativeTime:{future:{one:"in {0} Sekunde",other:"in {0} Sekunden"},past:{one:"vor {0} Sekunde",other:"vor {0} Sekunden"}}},"second-short":{displayName:"Sek.",relative:{0:"jetzt"},relativeTime:{future:{one:"in {0} Sek.",other:"in {0} Sek."},past:{one:"vor {0} Sek.",other:"vor {0} Sek."}}}}},{locale:"de-AT",parentLocale:"de"},{locale:"de-BE",parentLocale:"de"},{locale:"de-CH",parentLocale:"de"},{locale:"de-IT",parentLocale:"de"},{locale:"de-LI",parentLocale:"de"},{locale:"de-LU",parentLocale:"de"}]});


/***/ })

});