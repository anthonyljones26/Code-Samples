'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.messages = exports.locale = exports.areTranslationsLoaded = undefined;

var _reactIntl = require('react-intl');

var _pt = require('react-intl/locale-data/pt');

var _pt2 = _interopRequireDefault(_pt);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

(0, _reactIntl.addLocaleData)(_pt2.default);

var messages = {
  "Terra.AbstractModal.BeginModalDialog": "Iniciar diálogo modal",
  "Terra.AbstractModal.EndModalDialog": "Caixa de diálogo modal final",
  "Terra.ajax.error": "Falha ao carregar conteúdo.",
  "Terra.alert.advisory": "Informe.",
  "Terra.alert.alert": "Alerta.",
  "Terra.alert.dismiss": "Ignorar",
  "Terra.alert.error": "Erro.",
  "Terra.alert.info": "Informações.",
  "Terra.alert.success": "Êxito.",
  "Terra.alert.unsatisfied": "Ação exigida.",
  "Terra.alert.unverified": "Registros externos.",
  "Terra.alert.warning": "Aviso.",
  "Terra.form.field.optional": "(facultatif)",
  "Terra.form.select.add": "Adicionar \"{text}\"",
  "Terra.form.select.ariaLabel": "Pesquisar",
  "Terra.form.select.clearSelect": "Limpar seleção",
  "Terra.form.select.defaultDisplay": "- Selecione -",
  "Terra.form.select.defaultUsageGuidance": "Use as teclas de seta para cima e para baixo para navegar pelas opções. Pressione Enter para selecionar uma opção.",
  "Terra.form.select.dimmed": "Esmaecido.",
  "Terra.form.select.disabled": "Desativado.",
  "Terra.form.select.listOfTotalOptions": "Lista de {total} opções.",
  "Terra.form.select.maxSelectionHelp": "Limite de itens de {text}.",
  "Terra.form.select.maxSelectionOption": "Número máximo de itens de {text} selecionado",
  "Terra.form.select.menu": "Menu",
  "Terra.form.select.mobileButtonUsageGuidance": "Toque a tela para navegar para as opções.",
  "Terra.form.select.mobileUsageGuidance": "Deslize para a direita para acessar as opções.",
  "Terra.form.select.multiSelectUsageGuidance": "Insira o texto ou use as teclas de seta para cima e para baixo para navegar pelas opções. Pressione Enter para selecionar ou cancelar a seleção de uma opção.",
  "Terra.form.select.noResults": "Não há resultados para \"{text}\"",
  "Terra.form.select.optGroup": "Grupo {text}",
  "Terra.form.select.option": "Opções",
  "Terra.form.select.searchUsageGuidance": "Insira o texto ou use as teclas de seta para cima e para baixo para navegar pelas opções. Pressione Enter para selecionar uma opção.",
  "Terra.form.select.selectCleared": "Selecionar valor limpo",
  "Terra.form.select.selected": "Selecionado.",
  "Terra.form.select.selectedText": "{text} selecionado.",
  "Terra.form.select.unselected": "Não selecionado.",
  "Terra.form.select.unselectedText": "{text} não selecionado.",
  "Terra.icon.IconConsultInstructionsForUse.title": "Instruções eletrônicas para ícone de uso",
  "Terra.Overlay.loading": "Carregando..."
};
var areTranslationsLoaded = true;
var locale = 'pt-BR';
exports.areTranslationsLoaded = areTranslationsLoaded;
exports.locale = locale;
exports.messages = messages;
