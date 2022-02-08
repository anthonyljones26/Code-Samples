import React from 'react';
import PropTypes from 'prop-types';
import { injectIntl, intlShape } from 'react-intl';
import styles from './AllergyForm.scss';
import classNames from 'classnames/bind';
import { FormData } from '../models/form_data.model';
import RecentVisit from './RecentVisit';
import DeliveryMethod from './DeliveryMethod';
import clone from 'clone';
import { AllergyRefillManager } from '../managers/allergy-refill.manager';
import Button from 'terra-button';
import LoadingOverlay from 'terra-overlay/lib/LoadingOverlay';
import AbstractModal from 'terra-abstract-modal';
import { Address } from '../models/address.model';
import Insurance from './Insurance';
import Banner from 'tide-banner';
import Card from 'terra-card';

const cx = classNames.bind(styles);

const formNotice = cx(['form-notice']);
const errorColor = cx(['error']);
const copayLabelClass = cx(['copay-label']);

class AllergyForm extends React.Component {
  static propTypes = {
    activePatient: PropTypes.object.isRequired,
    setBanner: PropTypes.func.isRequired,
    updateFormData: PropTypes.func.isRequired,
    intl: intlShape
  }

  constructor(props) {
    super(props);
    this.state = {
      data: new FormData(),
      show: false
    };
  }

  updateRecentVisit = (value) => {
    let newData = clone(this.state.data);
    newData.setValue('recentVisit', value);

    this.setState({
      data: newData
    });
  }

  updatePaymentMethod = (value) => {
    let newData = clone(this.state.data);
    newData.setValue('paymentMethod', value);
    this.setState({
      data: newData
    });
  }

  updateDeliveryMethod = (value) => {
    let nData = clone(this.state.data);
    nData.setValue('deliveryMethod', value);
    this.setState({
      data: nData
    });
  }

  updateAddressMethod = (value) => {
    let newData = clone(this.state.data);
    newData.setValue('address', value);
    this.setState({
      data: newData
    });
  }

  getPickupAddress = () => {
    const streetAddress = this.props.intl.formatMessage({ id: 'allergy.deliveryMethod.pickupAddress.streetAddress1' });
    const city = this.props.intl.formatMessage({ id: 'allergy.deliveryMethod.pickupAddress.city' });
    const state = this.props.intl.formatMessage({ id: 'allergy.deliveryMethod.pickupAddress.state' });
    const postalCode = this.props.intl.formatMessage({ id: 'allergy.deliveryMethod.pickupAddress.postalCode' });

    let newAddress = new Address({
      streetAddress1: streetAddress,
      city: city,
      state: state,
      zipcode: postalCode
    });

    return newAddress;
  }

  submitRefill = (e) => {
    e.preventDefault();
    this.setState({
      show: true
    });
    AllergyRefillManager.storeAllergyRefill(this.state.data, this.props.activePatient.id).then((formData) => {
      this.setState({ show: false });
      this.props.updateFormData(formData);
    }, () => {
      this.props.setBanner('error', this.props.intl.formatMessage({ id: 'allergy.form.sendError.errorDetail' }));
      this.setState({ show: false });
      window.scrollTo(0, 0);
    });
  }

  render() {
    const { activePatient, intl } = this.props;
    const { data, show } = this.state;

    return (
      <div>
        <AbstractModal ariaLabel = 'sending-overlay' isOpen = { show } onRequestClose = { () => '' } isFullscreen>
          <LoadingOverlay
            isAnimated
            isOpen
            message = { intl.formatMessage({ id: 'allergy.form.sending' }) }
            backgroundStyle = 'clear'
          />
        </AbstractModal>
        <Card>
          <Card.Body>
            <form onSubmit = { this.submitRefill }>
              <div className = { formNotice }>
                <span className = { errorColor }>* </span>
                <span> { intl.formatMessage({ id: 'allergy.form.notice' }) } </span>
              </div>
              <div>
                <Insurance
                  updatePaymentMethod = { this.updatePaymentMethod }
                  insuranceList = { activePatient.health_plans }
                />
              </div>
              <RecentVisit
                recentVisit = { data.recentVisit }
                updateRecentVisit = { this.updateRecentVisit }
                display = { data.isValidPayment() }
              />
              <DeliveryMethod
                deliveryMethod = { data.deliveryMethod }
                updateDeliveryMethod = { this.updateDeliveryMethod }
                addressMethod = { this.updateAddressMethod }
                pickupAddress = { this.getPickupAddress() }
                display = { data.isValidPayment() && data.isValidRecentVisit() }
              />
              <br />
              { activePatient.isCopayAvailable && data.isValid() &&
                <Card>
                  <Card.Body className = 'copay-warning'>
                    <h3  className = { copayLabelClass }>
                      { intl.formatMessage({ id: 'allergy.copayLabel' }, { amount: window.tide.config.copayAmount }) }
                    </h3>
                    <Banner type = 'warning' title = { intl.formatMessage({ id: 'allergy.copayAlert' }) } />
                  </Card.Body>
                </Card>
              }
              <br />
              {  data.isValid() &&
                <Button
                  text = { intl.formatMessage({ id: 'allergy.form.send' }) }
                  variant = 'emphasis'
                  type = 'submit'
                />
              }
            </form>
          </Card.Body>
        </Card>
      </div>
    );
  }
}

export default injectIntl(AllergyForm);
