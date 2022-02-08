webpackJsonp([5],{

/***/ 935:
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.messages = exports.locale = exports.areTranslationsLoaded = undefined;

var _reactIntl = __webpack_require__(6);

var _nl = __webpack_require__(943);

var _nl2 = _interopRequireDefault(_nl);

function _interopRequireDefault(obj) {
  return obj && obj.__esModule ? obj : { default: obj };
}

(0, _reactIntl.addLocaleData)(_nl2.default);

var messages = {
  "Terra.AbstractModal.BeginModalDialog": "Begin de modale dialoog",
  "Terra.AbstractModal.EndModalDialog": "Modale dialoog beëindigen",
  "Terra.ajax.error": "Deze inhoud kon niet worden geladen.",
  "Terra.alert.advisory": "Adviserend.",
  "Terra.alert.alert": "Waarschuwing.",
  "Terra.alert.dismiss": "Negeren",
  "Terra.alert.error": "Fout.",
  "Terra.alert.info": "Informatie.",
  "Terra.alert.success": "Succes.",
  "Terra.alert.unsatisfied": "Vereiste actie.",
  "Terra.alert.unverified": "Externe records.",
  "Terra.alert.warning": "Waarschuwing.",
  "Terra.form.field.optional": "(optioneel)",
  "Terra.form.select.add": "\"{text}\" toevoegen",
  "Terra.form.select.ariaLabel": "Zoeken",
  "Terra.form.select.clearSelect": "Selectie wissen",
  "Terra.form.select.defaultDisplay": "- Selecteren -",
  "Terra.form.select.defaultUsageGuidance": "Gebruik de knoppen Pijl-omhoog en Pijl-omlaag om de opties te bekijken. Druk op Enter om een optie te selecteren.",
  "Terra.form.select.dimmed": "Gedimd.",
  "Terra.form.select.disabled": "Gedeactiveerd.",
  "Terra.form.select.listOfTotalOptions": "Lijst van {total} opties.",
  "Terra.form.select.maxSelectionHelp": "Limiet: {text} items.",
  "Terra.form.select.maxSelectionOption": "Maximumaantal van {text} items geselecteerd",
  "Terra.form.select.menu": "Menu",
  "Terra.form.select.mobileButtonUsageGuidance": "Tik om naar opties te gaan.",
  "Terra.form.select.mobileUsageGuidance": "Veeg naar rechts om naar opties te gaan.",
  "Terra.form.select.multiSelectUsageGuidance": "Voer tekst in of gebruik de knoppen Pijl-omhoog en Pijl-omlaag om de opties te bekijken. Druk op Enter om een optie te selecteren of te deselecteren.",
  "Terra.form.select.noResults": "Geen resultaten gevonden voor \"{text}\"",
  "Terra.form.select.optGroup": "Groeperen {text}",
  "Terra.form.select.option": "Opties",
  "Terra.form.select.searchUsageGuidance": "Voer tekst in of gebruik de knoppen Pijl-omhoog en Pijl-omlaag om de opties te bekijken. Druk op Enter om een optie te selecteren.",
  "Terra.form.select.selectCleared": "Geselecteerde waarde gewist",
  "Terra.form.select.selected": "Geselecteerd.",
  "Terra.form.select.selectedText": "{text} geselecteerd",
  "Terra.form.select.unselected": "Gedeselecteerd.",
  "Terra.form.select.unselectedText": "{text} niet geselecteerd.",
  "Terra.icon.IconConsultInstructionsForUse.title": "Pictogram Elektronische gebruiksaanwijzing",
  "Terra.Overlay.loading": "Bezig met laden"
};
var areTranslationsLoaded = true;
var locale = 'nl-BE';
exports.areTranslationsLoaded = areTranslationsLoaded;
exports.locale = locale;
exports.messages = messages;

/***/ }),

/***/ 943:
/***/ (function(module, exports, __webpack_require__) {

!function(e,n){ true?module.exports=n():"function"==typeof define&&define.amd?define(n):(e.ReactIntlLocaleData=e.ReactIntlLocaleData||{},e.ReactIntlLocaleData.nl=n())}(this,function(){"use strict";return[{locale:"nl",pluralRuleFunction:function(e,n){var a=!String(e).split(".")[1];return n?"other":1==e&&a?"one":"other"},fields:{year:{displayName:"jaar",relative:{0:"dit jaar",1:"volgend jaar","-1":"vorig jaar"},relativeTime:{future:{one:"over {0} jaar",other:"over {0} jaar"},past:{one:"{0} jaar geleden",other:"{0} jaar geleden"}}},"year-short":{displayName:"jr",relative:{0:"dit jaar",1:"volgend jaar","-1":"vorig jaar"},relativeTime:{future:{one:"over {0} jaar",other:"over {0} jaar"},past:{one:"{0} jaar geleden",other:"{0} jaar geleden"}}},month:{displayName:"maand",relative:{0:"deze maand",1:"volgende maand","-1":"vorige maand"},relativeTime:{future:{one:"over {0} maand",other:"over {0} maanden"},past:{one:"{0} maand geleden",other:"{0} maanden geleden"}}},"month-short":{displayName:"mnd",relative:{0:"deze maand",1:"volgende maand","-1":"vorige maand"},relativeTime:{future:{one:"over {0} maand",other:"over {0} maanden"},past:{one:"{0} maand geleden",other:"{0} maanden geleden"}}},day:{displayName:"dag",relative:{0:"vandaag",1:"morgen",2:"overmorgen","-2":"eergisteren","-1":"gisteren"},relativeTime:{future:{one:"over {0} dag",other:"over {0} dagen"},past:{one:"{0} dag geleden",other:"{0} dagen geleden"}}},"day-short":{displayName:"dag",relative:{0:"vandaag",1:"morgen",2:"overmorgen","-2":"eergisteren","-1":"gisteren"},relativeTime:{future:{one:"over {0} dag",other:"over {0} dgn"},past:{one:"{0} dag geleden",other:"{0} dgn geleden"}}},hour:{displayName:"uur",relative:{0:"binnen een uur"},relativeTime:{future:{one:"over {0} uur",other:"over {0} uur"},past:{one:"{0} uur geleden",other:"{0} uur geleden"}}},"hour-short":{displayName:"uur",relative:{0:"binnen een uur"},relativeTime:{future:{one:"over {0} uur",other:"over {0} uur"},past:{one:"{0} uur geleden",other:"{0} uur geleden"}}},minute:{displayName:"minuut",relative:{0:"binnen een minuut"},relativeTime:{future:{one:"over {0} minuut",other:"over {0} minuten"},past:{one:"{0} minuut geleden",other:"{0} minuten geleden"}}},"minute-short":{displayName:"min",relative:{0:"binnen een minuut"},relativeTime:{future:{one:"over {0} min.",other:"over {0} min."},past:{one:"{0} min. geleden",other:"{0} min. geleden"}}},second:{displayName:"seconde",relative:{0:"nu"},relativeTime:{future:{one:"over {0} seconde",other:"over {0} seconden"},past:{one:"{0} seconde geleden",other:"{0} seconden geleden"}}},"second-short":{displayName:"sec",relative:{0:"nu"},relativeTime:{future:{one:"over {0} sec.",other:"over {0} sec."},past:{one:"{0} sec. geleden",other:"{0} sec. geleden"}}}}},{locale:"nl-AW",parentLocale:"nl"},{locale:"nl-BE",parentLocale:"nl"},{locale:"nl-BQ",parentLocale:"nl"},{locale:"nl-CW",parentLocale:"nl"},{locale:"nl-SR",parentLocale:"nl"},{locale:"nl-SX",parentLocale:"nl"}]});


/***/ })

});