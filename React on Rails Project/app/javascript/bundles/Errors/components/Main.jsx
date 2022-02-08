import PropTypes from 'prop-types';
import React from 'react';
import Base from 'terra-base';
import { I18n } from 'i18n/translations';
import TideUtilsConvert from 'tide-utils-convert';
import ErrorMain from './ErrorMain';
import Dex from 'tide-dex';
import DexUtil from 'utils/dex.util';

const Main = ({ locale, status, errorPageLinks, dexConfig }) => {
  const customMessages = TideUtilsConvert.objectToDotNotation({ allergy: I18n[locale] });
  window.tide = window.tide || {};

  window.tide.dex = new Dex(dexConfig, { onReadyCallback: DexUtil.onReady });

  return (
    <Base locale = { locale } customMessages = { customMessages }>
      <ErrorMain status = { status } errorPageLinks = { errorPageLinks } />
    </Base>
  );
};

Main.propTypes = {
  locale: PropTypes.string.isRequired,
  status: PropTypes.string.isRequired,
  errorPageLinks: PropTypes.object,
  dexConfig: PropTypes.object
};

export default Main;
