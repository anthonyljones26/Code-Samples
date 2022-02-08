import { BloodPressureServiceManager } from './services/blood-pressure.service';

export class BloodPressureManager {
  static get STATUS_TYPE() {
    return {
      SUCCESS: 0,
      FAILURE: 1,
      REQUEST_TIMEOUT: 2,
      NO_DATA: 3
    };
  }

  static getBloodPressureEntries(dateRange) {
    return (new BloodPressureServiceManager()).getBloodPressure(dateRange)
      .then(results => {
        if (results.length === 0) {
          return Promise.reject(BloodPressureManager.STATUS_TYPE.NO_DATA);
        } else {
          return Promise.resolve(results);
        }
      }, httpStatus => {
        let statusType;
        if (httpStatus.isRequestTimeout()) {
          statusType = BloodPressureManager.STATUS_TYPE.REQUEST_TIMEOUT;
        } else {
          statusType = BloodPressureManager.STATUS_TYPE.FAILURE;
        }
        return Promise.reject(statusType);
      });
  }
}
