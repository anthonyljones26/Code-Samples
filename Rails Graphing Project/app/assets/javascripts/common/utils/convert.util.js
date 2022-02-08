import moment from 'moment';

export class ConvertUtil {
  static toString(x) {
    var type = typeof x;
    if ((type === 'number' && !isNaN(x)) || type === 'boolean') {
      x = String(x);
    }
    return (typeof x === 'string') ? x : undefined;
  }

  static toInteger(x) {
    if (typeof x === 'string') {
      x = (x.trim() === '') ? NaN : Number(x);
    }
    return (typeof x === 'number' && !isNaN(x) && (x | 0) === x) ? x : undefined;
  }

  static toDate(x) {
    if (typeof x === 'string') {
      x = new Date(x);
    }
    return (x instanceof Date && !isNaN(x.getTime())) ? x : undefined;
  }

  static toMoment(x) {
    if (typeof x === 'string') {
      x = moment(x);
    }
    return (moment.isMoment(x) && x.isValid()) ? x : undefined;
  }

  static toBoolean(x) {
    var type = typeof x;
    if (type === 'string') {
      if (x.toLowerCase() === 'true') {
        x = true;
      } else if (x.toLowerCase() === 'false') {
        x = false;
      }
    } else if (type === 'number') {
      x = ConvertUtil.integerToBoolean(x);
    }
    return (typeof x === 'boolean') ? x : undefined;
  }

  static dateToIsoString(date) {
    if (date instanceof Date) {
      return moment(date).format();
    } else if (moment.isMoment(date)) {
      return date.format();
    } else {
      return undefined;
    }
  }

  static dateToLocaleString(date) {
    if (date instanceof Date) {
      return moment(date).format('MMM DD, YYYY').toUpperCase();
    } else if (moment.isMoment(date)) {
      return date.format('MMM DD, YYYY').toUpperCase();
    } else {
      return undefined;
    }
  }

  static booleanToInteger(x) {
    x = ConvertUtil.toBoolean(x);
    if (typeof x === 'boolean') {
      return (x) ? 1 : 0;
    } else {
      return undefined;
    }
  }

  static integerToBoolean(x) {
    x = ConvertUtil.toInteger(x);
    if (typeof x === 'number') {
      return (x) ? true : false;
    } else {
      return undefined;
    }
  }
}
