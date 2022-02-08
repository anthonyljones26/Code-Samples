webpackJsonp([1],{

/***/ 939:
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.messages = exports.locale = exports.areTranslationsLoaded = undefined;

var _reactIntl = __webpack_require__(6);

var _sv = __webpack_require__(945);

var _sv2 = _interopRequireDefault(_sv);

function _interopRequireDefault(obj) {
  return obj && obj.__esModule ? obj : { default: obj };
}

(0, _reactIntl.addLocaleData)(_sv2.default);

var messages = {
  "Terra.AbstractModal.BeginModalDialog": "Börja modal dialog",
  "Terra.AbstractModal.EndModalDialog": "Avsluta modal dialog",
  "Terra.ajax.error": "Innehållet lästes inte in.",
  "Terra.alert.advisory": "Rådgivning.",
  "Terra.alert.alert": "Avisering.",
  "Terra.alert.dismiss": "Ignorera",
  "Terra.alert.error": "Fel.",
  "Terra.alert.info": "Information.",
  "Terra.alert.success": "Klar.",
  "Terra.alert.unsatisfied": "Nödvändig åtgärd krävs.",
  "Terra.alert.unverified": "Externa journaler.",
  "Terra.alert.warning": "Varning!",
  "Terra.form.field.optional": "(valfri)",
  "Terra.form.select.add": "Lägg till \"{text}\"",
  "Terra.form.select.ariaLabel": "Sök",
  "Terra.form.select.clearSelect": "Ta bort markering",
  "Terra.form.select.defaultDisplay": "- Välj -",
  "Terra.form.select.defaultUsageGuidance": "Använd upp- och nedpilarna för att navigera mellan alternativen. Tryck på Enter för att väklja ett alternativ.",
  "Terra.form.select.dimmed": "Inaktiverad.",
  "Terra.form.select.disabled": "Inaktiverad.",
  "Terra.form.select.listOfTotalOptions": "Lista med {total} alternativ.",
  "Terra.form.select.maxSelectionHelp": "Begränsa {text} antal poster.",
  "Terra.form.select.maxSelectionOption": "Max antal poster {text} är valda",
  "Terra.form.select.menu": "Meny",
  "Terra.form.select.mobileButtonUsageGuidance": "Tryck för att navigera till alternativen.",
  "Terra.form.select.mobileUsageGuidance": "Bläddra åt höger för att navigera till alternativen.",
  "Terra.form.select.multiSelectUsageGuidance": "Ange text eller använd upp- och nedpilarna för att navigera genom alternativen. Tryck på Enter för att markera eller avmarkera ett alternativ.",
  "Terra.form.select.noResults": "Inga matchande resultat för \"{text}\"",
  "Terra.form.select.optGroup": "Grupp {text}",
  "Terra.form.select.option": "Alternativ",
  "Terra.form.select.searchUsageGuidance": "Ange text eller använd upp- och nedpilarna för att navigera genom alternativen. Tryck på Enter för att välja ett alternativ.",
  "Terra.form.select.selectCleared": "Välj omarkerat värde",
  "Terra.form.select.selected": "Vald.",
  "Terra.form.select.selectedText": "{text} vald.",
  "Terra.form.select.unselected": "Omarkerad.",
  "Terra.form.select.unselectedText": "{text} avmarkerad.",
  "Terra.icon.IconConsultInstructionsForUse.title": "Indikator för elektroniska bruksanvisningar (eIFU)",
  "Terra.Overlay.loading": "Läser in ..."
};
var areTranslationsLoaded = true;
var locale = 'sv-SE';
exports.areTranslationsLoaded = areTranslationsLoaded;
exports.locale = locale;
exports.messages = messages;

/***/ }),

/***/ 945:
/***/ (function(module, exports, __webpack_require__) {

!function(e,r){ true?module.exports=r():"function"==typeof define&&define.amd?define(r):(e.ReactIntlLocaleData=e.ReactIntlLocaleData||{},e.ReactIntlLocaleData.sv=r())}(this,function(){"use strict";return[{locale:"sv",pluralRuleFunction:function(e,r){var t=String(e).split("."),a=!t[1],n=Number(t[0])==e,o=n&&t[0].slice(-1),m=n&&t[0].slice(-2);return r?1!=o&&2!=o||11==m||12==m?"other":"one":1==e&&a?"one":"other"},fields:{year:{displayName:"år",relative:{0:"i år",1:"nästa år","-1":"i fjol"},relativeTime:{future:{one:"om {0} år",other:"om {0} år"},past:{one:"för {0} år sedan",other:"för {0} år sedan"}}},"year-short":{displayName:"år",relative:{0:"i år",1:"nästa år","-1":"i fjol"},relativeTime:{future:{one:"om {0} år",other:"om {0} år"},past:{one:"för {0} år sen",other:"för {0} år sen"}}},month:{displayName:"månad",relative:{0:"denna månad",1:"nästa månad","-1":"förra månaden"},relativeTime:{future:{one:"om {0} månad",other:"om {0} månader"},past:{one:"för {0} månad sedan",other:"för {0} månader sedan"}}},"month-short":{displayName:"m",relative:{0:"denna mån.",1:"nästa mån.","-1":"förra mån."},relativeTime:{future:{one:"om {0} mån.",other:"om {0} mån."},past:{one:"för {0} mån. sen",other:"för {0} mån. sen"}}},day:{displayName:"dag",relative:{0:"i dag",1:"i morgon",2:"i övermorgon","-2":"i förrgår","-1":"i går"},relativeTime:{future:{one:"om {0} dag",other:"om {0} dagar"},past:{one:"för {0} dag sedan",other:"för {0} dagar sedan"}}},"day-short":{displayName:"dag",relative:{0:"i dag",1:"i morgon",2:"i övermorgon","-2":"i förrgår","-1":"i går"},relativeTime:{future:{one:"om {0} d",other:"om {0} d"},past:{one:"för {0} d sedan",other:"för {0} d sedan"}}},hour:{displayName:"timme",relative:{0:"denna timme"},relativeTime:{future:{one:"om {0} timme",other:"om {0} timmar"},past:{one:"för {0} timme sedan",other:"för {0} timmar sedan"}}},"hour-short":{displayName:"tim",relative:{0:"denna timme"},relativeTime:{future:{one:"om {0} tim",other:"om {0} tim"},past:{one:"för {0} tim sedan",other:"för {0} tim sedan"}}},minute:{displayName:"minut",relative:{0:"denna minut"},relativeTime:{future:{one:"om {0} minut",other:"om {0} minuter"},past:{one:"för {0} minut sedan",other:"för {0} minuter sedan"}}},"minute-short":{displayName:"min",relative:{0:"denna minut"},relativeTime:{future:{one:"om {0} min",other:"om {0} min"},past:{one:"för {0} min sen",other:"för {0} min sen"}}},second:{displayName:"sekund",relative:{0:"nu"},relativeTime:{future:{one:"om {0} sekund",other:"om {0} sekunder"},past:{one:"för {0} sekund sedan",other:"för {0} sekunder sedan"}}},"second-short":{displayName:"sek",relative:{0:"nu"},relativeTime:{future:{one:"om {0} sek",other:"om {0} sek"},past:{one:"för {0} s sen",other:"för {0} s sen"}}}}},{locale:"sv-AX",parentLocale:"sv"},{locale:"sv-FI",parentLocale:"sv"}]});


/***/ })

});