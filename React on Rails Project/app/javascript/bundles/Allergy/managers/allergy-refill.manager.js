import { AllergyRefillServiceManager } from './services/allergy-refill.service';
import { FormData } from '../models/form_data.model';

export class AllergyRefillManager {
  static get STATUS_TYPE() {
    return {
      SUCCESS: 0,
      FAILURE: 1,
      REQUEST_TIMEOUT: 2
    };
  }

  static storeAllergyRefill(refill, patientIndex) {
    let data;

    data = refill.toJsonCreate();
    data.patientIndex = patientIndex;
    return AllergyRefillServiceManager.saveRefill(data)
      .then(results => {
        if (results.length === 0) {
          return Promise.reject(AllergyRefillManager.STATUS_TYPE.FAILURE);
        }

        return Promise.resolve(FormData.fromJson(results.data));
      }, httpStatus => {
        let statusType;
        if (httpStatus.isRequestTimeout()) {
          statusType = AllergyRefillManager.STATUS_TYPE.REQUEST_TIMEOUT;
        } else {
          statusType = AllergyRefillManager.STATUS_TYPE.FAILURE;
        }
        return Promise.reject(statusType);
      });
  }
}
