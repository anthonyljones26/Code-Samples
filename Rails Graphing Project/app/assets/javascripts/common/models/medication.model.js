import { PropertyUtil } from '../utils/property.util';

export class Medication {
  static get STRUCTURE() {
    return {
      id: {
        type: 'integer',
        value: 0,
        jsonKey: 'id'
      },
      medication: {
        type: 'string',
        value: '',
        jsonKey: 'medication'
      },
      strength: {
        type: 'string',
        value: null,
        jsonKey: 'strength'
      },
      quantity: {
        type: 'string',
        value: null,
        jsonKey: 'quantity'
      },
      frequency: {
        type: 'string',
        value: null,
        jsonKey: 'frequency'
      },
      additionalInstructions: {
        type: 'string',
        value: null,
        jsonKey: 'additionalInstructions'
      },
      startDate: {
        type: 'moment',
        value: null,
        jsonKey: 'startDate'
      },
      endDate: {
        type: 'moment',
        value: null,
        jsonKey: 'endDate'
      },
      wasNotTaken: {
        type: 'boolean',
        value: null,
        jsonKey: 'wasNotTaken'
      },
      displayName: {
        type: 'string',
        value: '',
        jsonKey: 'medication'
      },
      category: {
        type: 'string',
        value: '',
        jsonKey: 'category'
      }
    };
  }

  static get DEFAULTS() {
    let defaults = {};
    Object.keys(Medication.STRUCTURE).map(function(key) {
      defaults[key] = Medication.STRUCTURE[key].value;
    });
    return defaults;
  }

  static fromJson(json) {
    if (typeof json === 'undefined' || typeof json !== 'object' || json === null) {
      throw 'invalid object';
    }

    let data = {};
    Object.keys(Medication.STRUCTURE).map(function(key) {
      data[key] = json[Medication.STRUCTURE[key].jsonKey];
    });

    return new Medication(data);
  }

  constructor(data) {
    if (typeof data === 'undefined' || typeof data !== 'object' || data === null) {
      data = {};
    } else {
      Object.keys(Medication.STRUCTURE).map(function(key) {
        switch (Medication.STRUCTURE[key].type) {
          case 'integer':
            PropertyUtil.toIntegerOrDelete(data, key);
            break;
          case 'moment':
            PropertyUtil.toMomentOrDelete(data, key);
            break;
          case 'boolean':
            PropertyUtil.toBooleanOrDelete(data, key);
            break;
          case 'string':
          default:
            PropertyUtil.toStringOrDelete(data, key);
            break;
        }
      });
    }

    Object.assign(this, Object.assign({}, Medication.DEFAULTS), data);
  }
}
