import React from 'react';
import PropTypes from 'prop-types';
import { injectIntl, intlShape } from 'react-intl';
import Card from 'terra-card';
import Field from 'terra-form-field';
import Input from 'terra-form-input';
import Grid from 'terra-grid';
import { Address } from '../models/address.model';
import clone from 'clone';

class MailForm extends React.Component {
  static propTypes = {
    addressMethod: PropTypes.func.isRequired,
    intl: intlShape
  };

  constructor(props) {
    super(props);
    this.state = {
      address: new Address(),
      isInvalidAddress1: false,
      isInvalidCity: false,
      isInvalidState: false,
      isInvalidPostalCode: false
    };
  }

  componentDidMount() {
    this.props.addressMethod(new Address());
  }

  handleInputChange = (event) => {

    let newAddress = clone(this.state.address);
    newAddress[event.target.name] = event.target.value;
    this.setState({ address: newAddress });

    this.props.addressMethod(newAddress);

    if (event.target.required) {
      switch (event.target.name) {
        case 'streetAddress1':
          this.setState({
            isInvalidAddress1: event.target.value.trim().length === 0
          });
          break;
        case 'city':
          this.setState({
            isInvalidCity: event.target.value.trim().length === 0
          });
          break;
        case 'state':
          this.setState({
            isInvalidState: event.target.value.trim().length === 0
          });
          break;
        case 'zipcode':
          this.setState({
            isInvalidPostalCode: event.target.value.trim().length === 0
          });
          break;
      }
    }
  }

  render() {
    const { intl } = this.props;
    return (
      <Card className = 'mail_form'>
        <Card.Body>
          <Grid>
            <Grid.Row>
              <Grid.Column small = { 12 } large = { 6 }>
                <Field
                  label = { intl.formatMessage({ id: 'allergy.deliveryMethod.mailform.streetAddress1' }) }
                  error = { intl.formatMessage({ id: 'allergy.requiredField' }) }
                  required
                  isInvalid = { this.state.isInvalidAddress1 }
                >
                  <Input
                    name = 'streetAddress1'
                    value = { this.state.address.streetAddress1 }
                    onChange = { this.handleInputChange }
                    required
                  />
                </Field>
              </Grid.Column>
            </Grid.Row>
            <Grid.Row>
              <Grid.Column small = { 12 } large = { 6 }>
                <Field
                  label = { intl.formatMessage({ id: 'allergy.deliveryMethod.mailform.streetAddress2' }) }
                  error = { intl.formatMessage({ id: 'allergy.requiredField' }) }
                >
                  <Input
                    name = 'streetAddress2'
                    value = { this.state.address.streetAddress2 }
                    onChange = { this.handleInputChange }
                  />
                </Field>
              </Grid.Column>
            </Grid.Row>
            <Grid.Row>
              <Grid.Column small = { 12 } large = { 6 }>
                <Field
                  label = { intl.formatMessage({ id: 'allergy.deliveryMethod.mailform.city' }) }
                  error = { intl.formatMessage({ id: 'allergy.requiredField' }) }
                  required
                  isInvalid = { this.state.isInvalidCity }
                >
                  <Input
                    name = 'city'
                    value = { this.state.address.city }
                    onChange = { this.handleInputChange }
                    required
                  />
                </Field>
              </Grid.Column>
              <Grid.Column small = { 12 } large = { 6 }>
                <Field
                  label = { intl.formatMessage({ id: 'allergy.deliveryMethod.mailform.state' }) }
                  error = { intl.formatMessage({ id: 'allergy.requiredField' }) }
                  required
                  isInvalid = { this.state.isInvalidState }
                >
                  <Input
                    name = 'state'
                    value = { this.state.address.state }
                    onChange = { this.handleInputChange }
                    required
                  />
                </Field>
              </Grid.Column>
            </Grid.Row>
            <Grid.Row>
              <Grid.Column small = { 12 } large = { 6 }>
                <Field
                  label = { intl.formatMessage({ id: 'allergy.deliveryMethod.mailform.postalCode' }) }
                  error = { intl.formatMessage({ id: 'allergy.deliveryMethod.mailform.error.postalCode' }) }
                  required
                  isInvalid = { this.state.isInvalidPostalCode }
                >
                  <Input
                    name = 'zipcode'
                    value = { this.state.address.zipcode }
                    onChange = { this.handleInputChange }
                    required
                  />
                </Field>
              </Grid.Column>
              <Grid.Column small = { 12 } large = { 6 }>
                <Field
                  label = { intl.formatMessage({ id: 'allergy.deliveryMethod.mailform.country' }) }
                  error = { intl.formatMessage({ id: 'allergy.requiredField' }) }
                  isInvalid = { false }
                >
                  <Input
                    name = 'country'
                    value = { this.state.address.country }
                    onChange = { this.handleInputChange }
                  />
                </Field>
              </Grid.Column>
            </Grid.Row>
          </Grid>
        </Card.Body>
      </Card>
    );
  }
}

export default injectIntl(MailForm);
