import { PropertyUtil } from '../utils/property.util';

export class BloodPressure {
  static get STRUCTURE() {
    return {
      date: {
        type: 'moment',
        value: null,
        jsonKey: 'date'
      },
      source: {
        type: 'string',
        value: '',
        jsonKey: 'source'
      },
      systolic: {
        type: 'integer',
        value: null,
        jsonKey: 'systolic'
      },
      sHigh: {
        type: 'integer',
        value: null,
        jsonKey: 'sHigh'
      },
      sLow: {
        type: 'integer',
        value: null,
        jsonKey: 'sLow'
      },
      diastolic: {
        type: 'integer',
        value: null,
        jsonKey: 'diastolic'
      },
      dHigh: {
        type: 'integer',
        value: null,
        jsonKey: 'dHigh'
      },
      dLow: {
        type: 'integer',
        value: null,
        jsonKey: 'dLow'
      }
    };
  }

  static get DEFAULTS() {
    let defaults = {};
    Object.keys(BloodPressure.STRUCTURE).map(function(key) {
      defaults[key] = BloodPressure.STRUCTURE[key].value;
    });
    return defaults;
  }

  static fromJson(json) {
    if (typeof json === 'undefined' || typeof json !== 'object' || json === null) {
      throw 'invalid object';
    }

    let data = {};
    Object.keys(BloodPressure.STRUCTURE).map(function(key) {
      data[key] = json[BloodPressure.STRUCTURE[key].jsonKey];
    });

    return new BloodPressure(data);
  }

  constructor(data) {
    if (typeof data === 'undefined' || typeof data !== 'object' || data === null) {
      data = {};
    } else {
      Object.keys(BloodPressure.STRUCTURE).map(function(key) {
        switch (BloodPressure.STRUCTURE[key].type) {
          case 'integer':
            PropertyUtil.toIntegerOrDelete(data, key);
            break;
          case 'moment':
            PropertyUtil.toMomentOrDelete(data, key);
            break;
          case 'string':
          default:
            PropertyUtil.toStringOrDelete(data, key);
            break;
        }
      });
    }

    Object.assign(this, Object.assign({}, BloodPressure.DEFAULTS), data);
  }
}
