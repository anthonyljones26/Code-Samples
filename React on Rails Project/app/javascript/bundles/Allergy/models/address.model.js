import TideModel from 'tide-model';

export class Address extends TideModel {
  static get STRUCTURE() {
    return {
      streetAddress1: {
        type: 'string',
        jsonKey: 'streetAddress1',
        value: ''
      },
      streetAddress2: {
        type: 'string',
        jsonKey: 'streetAddress2',
        value: ''
      },
      city: {
        type: 'string',
        jsonKey: 'city',
        value: ''
      },
      state: {
        type: 'string',
        jsonKey: 'state',
        value: ''
      },
      zipcode: {
        type: 'string',
        jsonKey: 'zipcode',
        value: ''
      },
      country: {
        type: 'string',
        jsonKey: 'country',
        value: ''
      }
    };
  }

  isValidAddress() {
    return (this.streetAddress1.trim() !== '' && this.city.trim() !== '' &&
      this.state.trim() !== '' && this.zipcode.trim() !== '');
  }

  toJsonCreate() {
    let data = {};
    data[Address.STRUCTURE.streetAddress1.jsonKey] = this.streetAddress1;
    data[Address.STRUCTURE.streetAddress2.jsonKey] = this.streetAddress2;
    data[Address.STRUCTURE.city.jsonKey] = this.city;
    data[Address.STRUCTURE.state.jsonKey] = this.state;
    data[Address.STRUCTURE.zipcode.jsonKey] = this.zipcode;
    data[Address.STRUCTURE.country.jsonKey] = this.country;
    return data;
  }
}
