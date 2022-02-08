import React from 'react';
import PropTypes from 'prop-types';
import { injectIntl, intlShape } from 'react-intl';
import { FormData } from '../models/form_data.model';
import SelectField from 'terra-form-select/lib/SelectField';
import Insurance from './Insurance';

class PaymentMethod extends React.Component {
  static propTypes = {
    updatePaymentMethod: PropTypes.func,
    paymentMethod: PropTypes.string,
    insuranceList: PropTypes.array,
    intl: intlShape
  };

  static defaultProps = {
    paymentMethod: FormData.INVALID_VALUE
  }

  constructor(props) {
    super(props);
    this.state = {
      paymentMethod: ''
    };
  }

  handleChange = (value) => {
    this.setState({
      paymentMethod: value
    });
    const selfPay = FormData.SELF_PAY;
    if (this.props.updatePaymentMethod) {
      if (value === selfPay) {
        this.props.updatePaymentMethod(value);
      } else {
        this.props.updatePaymentMethod(FormData.INVALID_VALUE);
      }
    }
  }

  payWithInsurance = () => {
    if (this.state.paymentMethod === FormData.INSURANCE_PAY) {
      return (
        <Insurance
          updatePaymentMethod = { this.props.updatePaymentMethod }
          insuranceList = { this.props.insuranceList }
        />
      );
    }
  };

  render() {
    const { intl } = this.props;
    return (
      <div>
        <SelectField
          label = { intl.formatMessage({ id: 'allergy.paymentMethod.label' }) }
          placeholder = { intl.formatMessage({ id: 'allergy.paymentMethod.placeholder' }) }
          selectId = 'payment-method-select-field'
          onChange = { this.handleChange }
          required
        >
          <SelectField.Option
            value = { FormData.INSURANCE_PAY }
            display = { intl.formatMessage({ id: 'allergy.paymentMethod.insurance' }) }
          />
          <SelectField.Option
            value = { FormData.SELF_PAY }
            display = { intl.formatMessage({ id: 'allergy.paymentMethod.selfPay' }) }
          />
        </SelectField>
        <div className = 'payment-style'>
          { this.payWithInsurance() }
        </div>
      </div>
    );
  }

}

export default injectIntl(PaymentMethod);
