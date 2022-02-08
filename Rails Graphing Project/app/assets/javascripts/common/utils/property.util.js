import { ConvertUtil } from './convert.util';

export class PropertyUtil {
  static toStringOrDelete(object, key) {
    if (object.hasOwnProperty(key)) {
      object[key] = ConvertUtil.toString(object[key]);
      if (typeof object[key] === 'undefined') {
        delete object[key];
      }
    }
  }

  static toIntegerOrDelete(object, key) {
    if (object.hasOwnProperty(key)) {
      object[key] = ConvertUtil.toInteger(object[key]);
      if (typeof object[key] === 'undefined') {
        delete object[key];
      }
    }
  }

  static toDateOrDelete(object, key) {
    if (object.hasOwnProperty(key)) {
      object[key] = ConvertUtil.toDate(object[key], false);
      if (typeof object[key] === 'undefined') {
        delete object[key];
      }
    }
  }

  static toMomentOrDelete(object, key) {
    if (object.hasOwnProperty(key)) {
      object[key] = ConvertUtil.toMoment(object[key], false);
      if (typeof object[key] === 'undefined') {
        delete object[key];
      }
    }
  }

  static toBooleanOrDelete(object, key) {
    if (object.hasOwnProperty(key)) {
      object[key] = ConvertUtil.toBoolean(object[key]);
      if (typeof object[key] === 'undefined') {
        delete object[key];
      }
    }
  }
}
