import PropTypes from 'prop-types';
import React from 'react';
import { injectIntl, intlShape } from 'react-intl';
import Heading from 'terra-heading';
import ContentContainer from 'terra-content-container';
import classNames from 'classnames/bind';
import styles from './SuccessMain.scss';
import AddressForm from './AddressForm';
import RecentVisitWarning from './RecentVisitWarning';
import { FormData } from '../models/form_data.model';
import Banner from 'tide-banner';
import Card from 'terra-card';

const cx = classNames.bind(styles);
const labelContainer = cx(['label', 'records-label']);
const headingContainer = cx(['heading-container']);
const contentSpacing = cx(['content-container']);

class SuccessMain extends React.Component {
  static propTypes = {
    patient: PropTypes.string.isRequired,
    data: PropTypes.instanceOf(FormData).isRequired,
    intl: intlShape.isRequired
  }

  constructor(props) {
    super(props);
  }

  bannerSelector = () => {
    return (this.props.data.isPickupDeliverMethod() ?
      <div>{ this.props.intl.formatMessage({ id: 'allergy.successPage.banner.pickUp' }) }</div> :
      <div>{ this.props.intl.formatMessage({ id: 'allergy.successPage.banner.mail' }) }</div>);
  }

  showDate = () => {
    const appointment = this.props.data.requestDateTime.format(
      this.props.intl.formatMessage({ id: 'allergy.successPage.dateTimeFormat' }));
    return (
      <div>{ appointment }</div>
    );
  }

  payWithInsurance = (data, intl) => {
    if (data.isPaymentMethodMU()) {
      return (
        <div className = 'copay-warning'>
          <p>{ intl.formatMessage({ id: 'allergy.copayLabel' }, { amount: window.tide.config.copayAmount }) }</p>
          <Banner type = 'warning'
            title = { intl.formatMessage({ id: 'allergy.copayAlert' }) }
          />
        </div>
      );
    }
    return (
      <div className = 'no-copay-detail'>
        { this.props.intl.formatMessage({ id: 'allergy.successPage.insuranceLabel' }) }
      </div>
    );
  };

  setLabel = (value) => {
    return (
      <div className = { labelContainer }>
        <p> { this.props.intl.formatMessage({ id: `allergy.successPage.${value}` }) } </p>
      </div>
    );
  }

  setHeading = (value) => {
    return (
      <Heading level = { 2 } weight = { 400 }>
        { this.props.intl.formatMessage({ id: `allergy.successPage.${value}` }) }
      </Heading>
    );
  }

  render() {
    const { patient, intl, data } = this.props;

    return (
      <div className = 'success-page-container'>
        <div className = 'banner-container'>
          <Banner  type = 'success'> { this.bannerSelector() } </Banner>
          <RecentVisitWarning display = { data.recentVisit === false } />
        </div>

        <Card>
          <Card.Body>
            { this.setLabel('recordsLabel') }

            <ContentContainer
              className = { headingContainer + ' patient-container' } header = { this.setHeading('heading.patient') }
            >
              <div className = { contentSpacing }> { patient } </div>
            </ContentContainer>

            <ContentContainer
              className = { headingContainer + ' date-container' } header = { this.setHeading('heading.dateTime') }
            >
              <div className = { contentSpacing } style = {{ whiteSpace: 'pre-line' }}> { this.showDate() } </div>
            </ContentContainer>

            <ContentContainer
              className = { headingContainer + ' payment-container' } header = { this.setHeading('heading.payment') }
            >
              <div className = { contentSpacing }> { this.payWithInsurance(data, intl) } </div>
            </ContentContainer>

            <ContentContainer
              className = { headingContainer + ' address-container' }
              header = {
                this.setHeading(data.isPickupDeliverMethod() ? 'heading.addressPickUp' : 'heading.addressMail') }
            >
              <div className = { contentSpacing }>
                <AddressForm
                  address = { data.address }
                  name = { data.isPickupDeliverMethod() ?
                    intl.formatMessage({ id: 'allergy.successPage.providerName' }) : patient }
                />
              </div>
            </ContentContainer>

            { this.setLabel('contactLabel') }
            { this.setLabel('recordsLabel') }
          </Card.Body>
        </Card>
      </div>
    );
  }
}

export default injectIntl(SuccessMain);
