import React from 'react';
import PropTypes from 'prop-types';
import { injectIntl, intlShape } from 'react-intl';
import AddressForm from './AddressForm';

class PickUpAddress extends React.Component {
  static propTypes = {
    addressMethod: PropTypes.func.isRequired,
    pickupAddress: PropTypes.object.isRequired,
    intl: intlShape
  };

  constructor(props) {
    super(props);
    this.pickupAddress = this.props.pickupAddress;
    this.props.addressMethod(this.pickupAddress);
  }

  render() {
    const { intl } = this.props;
    return (
      <div id = 'pickup-clinic-address'>
        <AddressForm
          name = { intl.formatMessage({ id: 'allergy.deliveryMethod.pickupAddress.name' }) }
          address = { this.pickupAddress }
          phoneNumber = { intl.formatMessage({ id: 'allergy.deliveryMethod.pickupAddress.phoneNumber' }) }
        />
      </div>
    );
  }
}

export default injectIntl(PickUpAddress);
