import TideModel from 'tide-model';
import { Address } from './address.model';

export class FormData extends TideModel {
  static get SELF_PAY() {
    return 'SELF_PAY';
  }
  static get INSURANCE_PAY() {
    return 'INSURANCE';
  }
  static get INVALID_VALUE() {
    return 'INVALID';
  }
  static get PICKUP() {
    return 'PICKUP';
  }
  static get DELIVER() {
    return 'DELIVER';
  }
  static get MU_INSURANCE_PAY() {
    return 'MU_INSURANCE';
  }
  static get STRUCTURE() {
    return {
      paymentMethod: {
        type: 'string',
        value: '',
        jsonKey: 'paymentMethod'
      },
      recentVisit: {
        type: 'boolean',
        value: null,
        jsonKey: 'recentVisit'
      },
      deliveryMethod: {
        type: 'string',
        value: '',
        jsonKey: 'deliveryMethod'
      },
      requestDateTime: {
        type: 'moment',
        value: null,
        jsonKey: 'requestDateTime'
      },
      address: {
        type: Address,
        value: new Address(),
        jsonKey: 'address'
      }
    };
  }

  isPickupDeliverMethod() {
    return this.deliveryMethod === FormData.PICKUP;
  }

  isPaymentMethodMU() {
    return this.paymentMethod === FormData.MU_INSURANCE_PAY;
  }

  isValid() {
    return this.isValidPayment() && this.isValidRecentVisit() && this.isValidDeliveryMethod() && this.isValidAddress();
    // && this.isValidDateTime();
  }

  isValidPayment() {
    return this.paymentMethod === FormData.INSURANCE_PAY || this.paymentMethod === FormData.SELF_PAY ||
      this.isPaymentMethodMU();
  }

  isValidRecentVisit() {
    return typeof(this.recentVisit) === 'boolean';
  }

  isValidDateTime() {
    return this.requestDateTime.isValid();
  }

  isValidDeliveryMethod() {
    return ((this.deliveryMethod === FormData.PICKUP) || (this.deliveryMethod === FormData.DELIVER));
  }

  isValidAddress() {
    return this.address.isValidAddress();
  }

  toJsonCreate() {
    let data = {};
    data[FormData.STRUCTURE.paymentMethod.jsonKey] = this.paymentMethod;
    data[FormData.STRUCTURE.recentVisit.jsonKey] = this.recentVisit;
    data[FormData.STRUCTURE.deliveryMethod.jsonKey] = this.deliveryMethod;
    data[FormData.STRUCTURE.address.jsonKey] = this.address.toJsonCreate();
    return data;
  }
}
