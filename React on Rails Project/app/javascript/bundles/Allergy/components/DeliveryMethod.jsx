import React from 'react';
import PropTypes from 'prop-types';
import { injectIntl, intlShape } from 'react-intl';
import { FormData } from '../models/form_data.model';
import SelectField from 'terra-form-select/lib/SelectField';
import MailForm from './MailForm';
import PickUpAddress from './PickUpAddress';

class DeliveryMethod extends React.Component {
  static propTypes = {
    deliveryMethod: PropTypes.string.isRequired,
    updateDeliveryMethod: PropTypes.func.isRequired,
    addressMethod: PropTypes.func.isRequired,
    pickupAddress: PropTypes.object.isRequired,
    display: PropTypes.bool,
    intl: intlShape
  };

  constructor(props) {
    super(props);
  }

  handleChange = (value) => {
    this.props.updateDeliveryMethod(value);
  }

  deliverRefill = () => {
    if (this.props.deliveryMethod === FormData.DELIVER) {
      return (
        <MailForm
          addressMethod = { this.props.addressMethod }
        />
      );
    }
  }

  pickupRefill = () => {
    if (this.props.deliveryMethod === FormData.PICKUP) {
      return (
        <PickUpAddress
          addressMethod = { this.props.addressMethod }
          pickupAddress = { this.props.pickupAddress }
        />
      );
    }
  }

  render() {
    const { display, intl, deliveryMethod } = this.props;
    if (!display) {
      return null;
    }
    return (
      <div>
        <SelectField
          label = { intl.formatMessage({ id: 'allergy.deliveryMethod.label' }) }
          placeholder = { intl.formatMessage({ id: 'allergy.deliveryMethod.placeholder' }) }
          selectId = 'delivery-method-select-field'
          onChange = { this.handleChange }
          maxWidth = '100%'
          variant = 'search' // This option prevents screen jump to top
          selectAttrs = {{ onFocus: (({ target }) => target.readOnly = true) }} //removing search ability on focus
          required
          value = { deliveryMethod }
        >
          <SelectField.Option
            value = { FormData.PICKUP }
            display = { intl.formatMessage({ id: 'allergy.deliveryMethod.pickup' }) }
          />
          <SelectField.Option
            value = { FormData.DELIVER }
            display = { intl.formatMessage({ id: 'allergy.deliveryMethod.deliver' }) }
          />
        </SelectField>
        <div className = 'payment-style'>
          { this.deliverRefill() }
        </div>
        <div>
          { this.pickupRefill() }
        </div>
      </div>
    );
  }

}

export default injectIntl(DeliveryMethod);
