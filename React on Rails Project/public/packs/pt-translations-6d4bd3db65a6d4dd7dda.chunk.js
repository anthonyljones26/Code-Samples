webpackJsonp([2],{869:function(e,a,o){"use strict";Object.defineProperty(a,"__esModule",{value:!0}),a.messages=a.locale=a.areTranslationsLoaded=void 0;var r,t=o(6),s=o(877),n=(r=s)&&r.__esModule?r:{default:r};(0,t.addLocaleData)(n.default);a.areTranslationsLoaded=!0,a.locale="pt",a.messages={"Terra.AbstractModal.BeginModalDialog":"Iniciar di\xe1logo modal","Terra.AbstractModal.EndModalDialog":"Caixa de di\xe1logo modal final","Terra.ajax.error":"Falha ao carregar conte\xfado.","Terra.alert.advisory":"Informe.","Terra.alert.alert":"Alerta.","Terra.alert.dismiss":"Ignorar","Terra.alert.error":"Erro.","Terra.alert.info":"Informa\xe7\xf5es.","Terra.alert.success":"\xcaxito.","Terra.alert.unsatisfied":"A\xe7\xe3o exigida.","Terra.alert.unverified":"Registros externos.","Terra.alert.warning":"Aviso.","Terra.form.field.optional":"(opcional)","Terra.form.select.add":'Adicionar "{text}"',"Terra.form.select.ariaLabel":"Pesquisar","Terra.form.select.clearSelect":"Limpar sele\xe7\xe3o","Terra.form.select.defaultDisplay":"- Selecione -","Terra.form.select.defaultUsageGuidance":"Use as teclas de seta para cima e para baixo para navegar pelas op\xe7\xf5es. Pressione Enter para selecionar uma op\xe7\xe3o.","Terra.form.select.dimmed":"Esmaecido.","Terra.form.select.disabled":"Desativado.","Terra.form.select.listOfTotalOptions":"Lista de {total} op\xe7\xf5es.","Terra.form.select.maxSelectionHelp":"Limite de itens de {text}.","Terra.form.select.maxSelectionOption":"N\xfamero m\xe1ximo de itens de {text} selecionado","Terra.form.select.menu":"Menu","Terra.form.select.mobileButtonUsageGuidance":"Toque a tela para navegar para as op\xe7\xf5es.","Terra.form.select.mobileUsageGuidance":"Deslize para a direita para acessar as op\xe7\xf5es.","Terra.form.select.multiSelectUsageGuidance":"Insira o texto ou use as teclas de seta para cima e para baixo para navegar pelas op\xe7\xf5es. Pressione Enter para selecionar ou cancelar a sele\xe7\xe3o de uma op\xe7\xe3o.","Terra.form.select.noResults":'N\xe3o h\xe1 resultados para "{text}"',"Terra.form.select.optGroup":"Grupo {text}","Terra.form.select.option":"Op\xe7\xf5es","Terra.form.select.searchUsageGuidance":"Insira o texto ou use as teclas de seta para cima e para baixo para navegar pelas op\xe7\xf5es. Pressione Enter para selecionar uma op\xe7\xe3o.","Terra.form.select.selectCleared":"Selecionar valor limpo","Terra.form.select.selected":"Selecionado.","Terra.form.select.selectedText":"{text} selecionado.","Terra.form.select.unselected":"N\xe3o selecionado.","Terra.form.select.unselectedText":"{text} n\xe3o selecionado.","Terra.icon.IconConsultInstructionsForUse.title":"Instru\xe7\xf5es eletr\xf4nicas para \xedcone de uso","Terra.Overlay.loading":"Carregando..."}},877:function(e,a,o){var r;r=function(){"use strict";return[{locale:"pt",pluralRuleFunction:function(e,a){var o=String(e).split(".")[0];return a?"other":0==o||1==o?"one":"other"},fields:{year:{displayName:"ano",relative:{0:"este ano",1:"pr\xf3ximo ano","-1":"ano passado"},relativeTime:{future:{one:"em {0} ano",other:"em {0} anos"},past:{one:"h\xe1 {0} ano",other:"h\xe1 {0} anos"}}},"year-short":{displayName:"ano",relative:{0:"este ano",1:"pr\xf3ximo ano","-1":"ano passado"},relativeTime:{future:{one:"em {0} ano",other:"em {0} anos"},past:{one:"h\xe1 {0} ano",other:"h\xe1 {0} anos"}}},month:{displayName:"m\xeas",relative:{0:"este m\xeas",1:"pr\xf3ximo m\xeas","-1":"m\xeas passado"},relativeTime:{future:{one:"em {0} m\xeas",other:"em {0} meses"},past:{one:"h\xe1 {0} m\xeas",other:"h\xe1 {0} meses"}}},"month-short":{displayName:"m\xeas",relative:{0:"este m\xeas",1:"pr\xf3ximo m\xeas","-1":"m\xeas passado"},relativeTime:{future:{one:"em {0} m\xeas",other:"em {0} meses"},past:{one:"h\xe1 {0} m\xeas",other:"h\xe1 {0} meses"}}},day:{displayName:"dia",relative:{0:"hoje",1:"amanh\xe3",2:"depois de amanh\xe3","-2":"anteontem","-1":"ontem"},relativeTime:{future:{one:"em {0} dia",other:"em {0} dias"},past:{one:"h\xe1 {0} dia",other:"h\xe1 {0} dias"}}},"day-short":{displayName:"dia",relative:{0:"hoje",1:"amanh\xe3",2:"depois de amanh\xe3","-2":"anteontem","-1":"ontem"},relativeTime:{future:{one:"em {0} dia",other:"em {0} dias"},past:{one:"h\xe1 {0} dia",other:"h\xe1 {0} dias"}}},hour:{displayName:"hora",relative:{0:"esta hora"},relativeTime:{future:{one:"em {0} hora",other:"em {0} horas"},past:{one:"h\xe1 {0} hora",other:"h\xe1 {0} horas"}}},"hour-short":{displayName:"h",relative:{0:"esta hora"},relativeTime:{future:{one:"em {0} h",other:"em {0} h"},past:{one:"h\xe1 {0} h",other:"h\xe1 {0} h"}}},minute:{displayName:"minuto",relative:{0:"este minuto"},relativeTime:{future:{one:"em {0} minuto",other:"em {0} minutos"},past:{one:"h\xe1 {0} minuto",other:"h\xe1 {0} minutos"}}},"minute-short":{displayName:"min.",relative:{0:"este minuto"},relativeTime:{future:{one:"em {0} min.",other:"em {0} min."},past:{one:"h\xe1 {0} min.",other:"h\xe1 {0} min."}}},second:{displayName:"segundo",relative:{0:"agora"},relativeTime:{future:{one:"em {0} segundo",other:"em {0} segundos"},past:{one:"h\xe1 {0} segundo",other:"h\xe1 {0} segundos"}}},"second-short":{displayName:"seg.",relative:{0:"agora"},relativeTime:{future:{one:"em {0} seg.",other:"em {0} seg."},past:{one:"h\xe1 {0} seg.",other:"h\xe1 {0} seg."}}}}},{locale:"pt-AO",parentLocale:"pt-PT"},{locale:"pt-PT",parentLocale:"pt",pluralRuleFunction:function(e,a){var o=!String(e).split(".")[1];return a?"other":1==e&&o?"one":"other"},fields:{year:{displayName:"ano",relative:{0:"este ano",1:"pr\xf3ximo ano","-1":"ano passado"},relativeTime:{future:{one:"dentro de {0} ano",other:"dentro de {0} anos"},past:{one:"h\xe1 {0} ano",other:"h\xe1 {0} anos"}}},"year-short":{displayName:"ano",relative:{0:"este ano",1:"pr\xf3ximo ano","-1":"ano passado"},relativeTime:{future:{one:"dentro de {0} ano",other:"dentro de {0} anos"},past:{one:"h\xe1 {0} ano",other:"h\xe1 {0} anos"}}},month:{displayName:"m\xeas",relative:{0:"este m\xeas",1:"pr\xf3ximo m\xeas","-1":"m\xeas passado"},relativeTime:{future:{one:"dentro de {0} m\xeas",other:"dentro de {0} meses"},past:{one:"h\xe1 {0} m\xeas",other:"h\xe1 {0} meses"}}},"month-short":{displayName:"m\xeas",relative:{0:"este m\xeas",1:"pr\xf3ximo m\xeas","-1":"m\xeas passado"},relativeTime:{future:{one:"dentro de {0} m\xeas",other:"dentro de {0} meses"},past:{one:"h\xe1 {0} m\xeas",other:"h\xe1 {0} meses"}}},day:{displayName:"dia",relative:{0:"hoje",1:"amanh\xe3",2:"depois de amanh\xe3","-2":"anteontem","-1":"ontem"},relativeTime:{future:{one:"dentro de {0} dia",other:"dentro de {0} dias"},past:{one:"h\xe1 {0} dia",other:"h\xe1 {0} dias"}}},"day-short":{displayName:"dia",relative:{0:"hoje",1:"amanh\xe3",2:"depois de amanh\xe3","-2":"anteontem","-1":"ontem"},relativeTime:{future:{one:"dentro de {0} dia",other:"dentro de {0} dias"},past:{one:"h\xe1 {0} dia",other:"h\xe1 {0} dias"}}},hour:{displayName:"hora",relative:{0:"esta hora"},relativeTime:{future:{one:"dentro de {0} hora",other:"dentro de {0} horas"},past:{one:"h\xe1 {0} hora",other:"h\xe1 {0} horas"}}},"hour-short":{displayName:"h",relative:{0:"esta hora"},relativeTime:{future:{one:"dentro de {0} h",other:"dentro de {0} h"},past:{one:"h\xe1 {0} h",other:"h\xe1 {0} h"}}},minute:{displayName:"minuto",relative:{0:"este minuto"},relativeTime:{future:{one:"dentro de {0} minuto",other:"dentro de {0} minutos"},past:{one:"h\xe1 {0} minuto",other:"h\xe1 {0} minutos"}}},"minute-short":{displayName:"min",relative:{0:"este minuto"},relativeTime:{future:{one:"dentro de {0} min",other:"dentro de {0} min"},past:{one:"h\xe1 {0} min",other:"h\xe1 {0} min"}}},second:{displayName:"segundo",relative:{0:"agora"},relativeTime:{future:{one:"dentro de {0} segundo",other:"dentro de {0} segundos"},past:{one:"h\xe1 {0} segundo",other:"h\xe1 {0} segundos"}}},"second-short":{displayName:"s",relative:{0:"agora"},relativeTime:{future:{one:"dentro de {0} s",other:"dentro de {0} s"},past:{one:"h\xe1 {0} s",other:"h\xe1 {0} s"}}}}},{locale:"pt-CH",parentLocale:"pt-PT"},{locale:"pt-CV",parentLocale:"pt-PT"},{locale:"pt-GQ",parentLocale:"pt-PT"},{locale:"pt-GW",parentLocale:"pt-PT"},{locale:"pt-LU",parentLocale:"pt-PT"},{locale:"pt-MO",parentLocale:"pt-PT"},{locale:"pt-MZ",parentLocale:"pt-PT"},{locale:"pt-ST",parentLocale:"pt-PT"},{locale:"pt-TL",parentLocale:"pt-PT"}]},e.exports=r()}});
//# sourceMappingURL=pt-translations-6d4bd3db65a6d4dd7dda.chunk.js.map