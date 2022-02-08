import PropTypes from 'prop-types';
import React from 'react';
import Base from 'terra-base';
import { I18n } from 'i18n/translations';
import TideUtilsConvert from 'tide-utils-convert';
import clone from 'clone';
import RefillMain from './RefillMain';
import SuccessMain from './SuccessMain';
import { FormData } from '../models/form_data.model';
import Dex from 'tide-dex';
import DexUtil from 'utils/dex.util';

export default class Main extends React.Component {
  static propTypes = {
    locale: PropTypes.string.isRequired,
    patients: PropTypes.array.isRequired,
    activePatient: PropTypes.number.isRequired,
    config: PropTypes.object.isRequired,
    dexConfig: PropTypes.object.isRequired
  }

  constructor(props) {
    super(props);
    this.locale = this.props.locale;
    this.state = {
      data: new FormData()
    };

    window.tide = window.tide || {};

    window.tide.config = this.props.config;
    window.tide.patients = this.props.patients;
    window.tide.activePatient = this.props.activePatient;
    window.tide.dex = new Dex(this.props.dexConfig, { onReadyCallback: DexUtil.onReady });
  }

  updateFormData = (value) => {
    let newData = clone(value);
    this.setState({
      data: newData
    });
  }

  viewPicker = () => {
    return (this.state.data.isValid() ?
      <SuccessMain
        patient = { this.props.patients[this.props.activePatient].name }
        data = { this.state.data }
      /> :
      <RefillMain
        patients = { this.props.patients }
        activePatient = { this.props.activePatient }
        updateFormData = { this.updateFormData }
      />
    );
  }

  componentDidUpdate() {
    window.scrollTo(0, 0);
  }
  //add context with intl object for the locale

  render() {
    const customMessages = TideUtilsConvert.objectToDotNotation({ allergy: I18n[this.locale] });
    return (
      //<Base locale = { this.locale } className = 'main-base'>
      <Base locale = { this.locale } className = 'main-base' customMessages = { customMessages }>
        { this.viewPicker() }
      </Base>
    );
  }
}
