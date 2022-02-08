import React from 'react';
import PropTypes from 'prop-types';
import { injectIntl, intlShape } from 'react-intl';
import { FormData } from '../models/form_data.model';
import SelectField from 'terra-form-select/lib/SelectField';
import Banner from 'tide-banner';
import Card from 'terra-card';
import { FormattedMessage } from 'react-intl';

class Insurance extends React.Component {
  static propTypes = {
    updatePaymentMethod: PropTypes.func.isRequired,
    insuranceList: PropTypes.array,
    intl: intlShape
  };

  static defaultProps = {
    insuranceList: []
  };

  constructor(props) {
    super(props);
    this.state = {
      currentInsurance: ''
    };
  }

  handleChange = (value) => {
    this.setState({
      currentInsurance: value
    });
    this.props.updatePaymentMethod(value);
  }

  alertBox = () => {
    if (this.state.currentInsurance === FormData.INVALID_VALUE) {
      const clinicNumLink = window.tide.config.phoneNumbers.allergyClinic;
      return (
        <Banner className = 'insurance-plan-warning' type = 'warning'
          title = { this.props.intl.formatMessage({ id: 'allergy.payWithInsurance.currentInsurance.error' }) }
        >
          <FormattedMessage
            id = 'allergy.payWithInsurance.currentInsurance.errorDetail'
            values = {{ telNumberText: <a href = { 'tel:' + clinicNumLink }>{ clinicNumLink }</a> }}
          />
        </Banner>
      );
    }
  }

  insuranceView = (insuranceList, intl) => {
    return insuranceList.map(function(insurance, index) {
      return (
        <div key = { index }>
          <strong>
            { intl.formatMessage({ id: 'allergy.payWithInsurance.label' }) + ' ' }
          </strong>
          { insurance }
        </div>
      );
    });
  }

  render() {
    const { insuranceList, intl } = this.props;

    if (insuranceList === null) {
      const insuranceNumLink = window.tide.config.phoneNumbers.insuranceError;
      return (
        <Banner className = 'insurance-error' type = 'error'
          title = { intl.formatMessage({ id: 'allergy.payWithInsurance.insuranceError.error' }) }
        >
          <FormattedMessage
            id = 'allergy.payWithInsurance.insuranceError.errorDetail'
            values = {{ telNumberText: <a href = { 'tel:' + insuranceNumLink }>{ insuranceNumLink }</a> }}
          />
        </Banner>
      );
    }

    if (insuranceList.length === 0) {
      const clinicNumLink = window.tide.config.phoneNumbers.allergyClinic;
      return (
        <Banner className = 'no-insurance-warning' type = 'warning'
          title = { intl.formatMessage({ id: 'allergy.payWithInsurance.noInsurance.error' }) }
        >
          <FormattedMessage
            id = 'allergy.payWithInsurance.noInsurance.errorDetail'
            values = {{ telNumberText: <a href = { 'tel:' + clinicNumLink }>{ clinicNumLink }</a> }}
          />
        </Banner>
      );
    }

    return (
      <div className = 'insurance-plan'>
        <Card>
          <Card.Body>
            { this.insuranceView(insuranceList, intl) }
          </Card.Body>
          <Card.Body>
            <SelectField
              label = { intl.formatMessage({ id: 'allergy.payWithInsurance.currentInsurance.label' }) }
              placeholder = { intl.formatMessage({ id: 'allergy.payWithInsurance.currentInsurance.placeholder' }) }
              selectId = 'current-insurance-select-field'
              onChange = { this.handleChange }
              maxWidth = '100%'
              variant = 'search' // This option prevents screen jump to top
              selectAttrs = {{ onFocus: (({ target }) => target.readOnly = true) }} //removing search ability on focus
              required
            >
              <SelectField.Option
                value = { FormData.INSURANCE_PAY }
                display = { intl.formatMessage({ id: 'allergy.payWithInsurance.currentInsurance.yes' }) }
              />
              <SelectField.Option
                value = { FormData.INVALID_VALUE }
                display = { intl.formatMessage({ id: 'allergy.payWithInsurance.currentInsurance.no' }) }
              />
            </SelectField>
            { this.alertBox() }
          </Card.Body>
        </Card>
        <br />
      </div>
    );
  }
}

export default injectIntl(Insurance);
