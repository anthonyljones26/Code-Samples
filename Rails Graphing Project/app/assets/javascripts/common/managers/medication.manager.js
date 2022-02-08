import { MedicationServiceManager } from './services/medication.service';

export class MedicationManager {
  static get STATUS_TYPE() {
    return {
      SUCCESS: 0,
      FAILURE: 1,
      REQUEST_TIMEOUT: 2,
      NO_DATA: 3
    };
  }

  static getMedicationEntries(dateRange) {

    return (new MedicationServiceManager()).getMedication(dateRange)
      .then(results => {
        if (results.length === 0) {
          return Promise.reject(MedicationManager.STATUS_TYPE.NO_DATA);
        } else {
          return Promise.resolve(results);
        }
      }, httpStatus => {
        let statusType;
        if (httpStatus.isRequestTimeout()) {
          statusType = MedicationManager.STATUS_TYPE.REQUEST_TIMEOUT;
        } else {
          statusType = MedicationManager.STATUS_TYPE.FAILURE;
        }
        return Promise.reject(statusType);
      });
  }
}
