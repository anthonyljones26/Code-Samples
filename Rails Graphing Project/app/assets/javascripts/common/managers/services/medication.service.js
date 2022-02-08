import { BaseServiceManager } from './base.service';
import { Medication } from '../../models/medication.model';
import { ConvertUtil } from '../../utils/convert.util';
import { HttpStatus } from '../../models/http-status.model';

export class MedicationServiceManager extends BaseServiceManager {
  constructor() {
    super();
    this.debug = false;
  }

  getMedication(dateRange) {
    let data = {
      start: ConvertUtil.dateToIsoString(dateRange.start),
      end: ConvertUtil.dateToIsoString(dateRange.end)
    };

    return Promise.resolve()
      .then(() => {
        return (this.debug) ? this.mockData(data) : this.executeGetRequest(ROUTES.med_graph_data, data);
      })
      .then(response => {
        if (response.httpStatus.isOk()) {
          let results = [], i;
          for (i = response.data.length - 1; i >= 0; i--) {
            results.push(Medication.fromJson(response.data[i]));
          }
          return Promise.resolve(results);
        } else {
          return Promise.reject(response.httpStatus);
        }
      }, error => {
        return Promise.reject(error.httpStatus);
      });
  }

  mockData(data) {
    let results;
    let currentDate = new Date();
    let toTestDate = function(currentDate, offsetDays) {
      return (new Date(currentDate.getTime() + (offsetDays * 86400000))).toISOString();
    };

    results = [
      {
        'id': 18,
        'medication': '1Acebutolol',
        'quantity': '200mg',
        'startDate': toTestDate(currentDate, -5),
        'endDate': toTestDate(currentDate, -3),
        'wasNotTaken': true,
        'strength': '200mg',
        'frequency': '',
        'additionalInstructions': '',
        'displayName': '1Acebutolol',
        'category': 'inpatient'

      },
      {
        'id': 19,
        'medication': '1Acebutolol',
        'quantity': '400MG',
        'startDate': toTestDate(currentDate, -5),
        'endDate': toTestDate(currentDate, -3),
        'wasNotTaken': true,
        'strength': '400MG',
        'frequency': '',
        'additionalInstructions': '',
        'displayName': '1Acebutolol',
        'category': 'inpatient'

      },
      {
        'id': 1,
        'medication': 'MEDs',
        'quantity': '25mg',
        'startDate': toTestDate(currentDate, -45),
        'endDate': toTestDate(currentDate, 0),
        'wasNotTaken': true,
        'strength': '25mg',
        'frequency': '',
        'additionalInstructions': '',
        'displayName': 'MEDs',
        'category': 'outpatient'
      },
      {
        'id': 2,
        'medication': 'different meds',
        'quantity': '1050mg',
        'startDate': toTestDate(currentDate, -120),
        'endDate': toTestDate(currentDate, -1),
        'wasNotTaken': false,
        'strength': '1050mg',
        'frequency': '',
        'additionalInstructions': '',
        'displayName': 'different meds',
        'category': 'outpatient'
      },
      {
        'id': 3,
        'medication': 'Really Really Really Really Long Meds Name Here',
        'quantity': '550mg',
        'startDate': toTestDate(currentDate, -85),
        'endDate': toTestDate(currentDate, -6),
        'wasNotTaken': false,
        'strength': '550mg',
        'frequency': '',
        'additionalInstructions': '',
        'displayName': 'Really Really Really Really Long Meds Name Here',
        'category': 'outpatient'
      },
      {
        'id': 4,
        'medication': '1 meds',
        'quantity': '1051 Mg',
        'startDate': toTestDate(currentDate, -55),
        'endDate': toTestDate(currentDate, -19),
        'wasNotTaken': true,
        'strength': '1050 mg',
        'frequency': '',
        'additionalInstructions': '',
        'displayName': '1 Meds',
        'category': 'outpatient'

      },
      {
        'id': -1,
        'medication': '1 Meds',
        'quantity': '1052 Mg',
        'startDate': toTestDate(currentDate, -54),
        'endDate': toTestDate(currentDate, -20),
        'wasNotTaken': true,
        'strength': '1050 Mg',
        'frequency': '',
        'additionalInstructions': '',
        'displayName': '1 Meds',
        'category': 'outpatient'

      },
      {
        'id': 5,
        'medication': '1 MedS',
        'quantity': '1050 Mg',
        'startDate': toTestDate(currentDate, -41),
        'endDate': toTestDate(currentDate, -7),
        'wasNotTaken': false,
        'strength': '1050 MG',
        'frequency': '',
        'additionalInstructions': '',
        'displayName': '1 Meds',
        'category': 'outpatient'
      },
      {
        'id': 6,
        'medication': '3 meds',
        'quantity': '1050mg',
        'startDate': toTestDate(currentDate, -100),
        'endDate': toTestDate(currentDate, -60),
        'wasNotTaken': false,
        'strength': '',
        'frequency': '',
        'additionalInstructions': '',
        'displayName': '3 meds',
        'category': 'outpatient'
      },
      {
        'id': 7,
        'medication': '4 meds',
        'quantity': '1050mg',
        'startDate': toTestDate(currentDate, -700),
        'endDate': toTestDate(currentDate, -365),
        'wasNotTaken': false,
        'strength': '1050mg',
        'frequency': '',
        'additionalInstructions': '',
        'displayName': '4 meds',
        'category': 'outpatient'
      },
      {
        'id': 8,
        'medication': '5 meds',
        'quantity': '1 Tab',
        'startDate': toTestDate(currentDate, -425),
        'endDate': toTestDate(currentDate, -400),
        'wasNotTaken': false,
        'strength': '',
        'frequency': '',
        'additionalInstructions': '',
        'displayName': '5 meds',
        'category': 'outpatient'
      },
      {
        'id': 9,
        'medication': '6 meds',
        'quantity': '1050mg',
        'startDate': toTestDate(currentDate, -750),
        'endDate': toTestDate(currentDate, -700),
        'wasNotTaken': false,
        'strength': '',
        'frequency': '',
        'additionalInstructions': '',
        'displayName': '6 meds',
        'category': 'outpatient'
      },
      {
        'id': 10,
        'medication': 'new med',
        'quantity': '950mg',
        'startDate': toTestDate(currentDate, -1),
        'endDate': toTestDate(currentDate, 0),
        'wasNotTaken': true,
        'strength': '150 MG',
        'frequency': '',
        'additionalInstructions': '',
        'displayName': 'new med',
        'category': 'inpatient'
      },
      {
        'id': 11,
        'medication': 'one meds',
        'quantity': '65mg',
        'startDate': toTestDate(currentDate, -14),
        'endDate': toTestDate(currentDate, -7),
        'wasNotTaken': true,
        'strength': '',
        'frequency': '',
        'additionalInstructions': '',
        'displayName': 'one meds',
        'category': 'outpatient'
      },
      {
        'id': 12,
        'medication': 'one meds',
        'quantity': '65mg',
        'startDate': toTestDate(currentDate, -28),
        'endDate': toTestDate(currentDate, -52),
        'wasNotTaken': false,
        'strength': '',
        'frequency': '',
        'additionalInstructions': '',
        'displayName': 'one meds',
        'category': 'outpatient'
      },
      {
        'id': 13,
        'medication': 'old med',
        'quantity': '14kg',
        'startDate': '2011-03-20',
        'endDate': '2015-04-21',
        'wasNotTaken': true,
        'strength': '',
        'frequency': '',
        'additionalInstructions': '',
        'displayName': 'old med',
        'category': 'outpatient'
      },
      {
        'id': 14,
        'medication': 'today\'s med (1)',
        'quantity': '14kg',
        'startDate': toTestDate(currentDate, -1 * ((1000 * 60 * 2) / 86400000)),
        'endDate': toTestDate(currentDate, 10),
        'wasNotTaken': true,
        'strength': '200 mg + 400 mg',
        'frequency': '',
        'additionalInstructions': '',
        'displayName': 'today\'s med (1)',
        'category': 'inpatient'
      },
      {
        'id': 15,
        'medication': 'today\'s med (2)',
        'quantity': '14kg',
        'startDate': toTestDate(currentDate, -1 * ((1000 * 60 * 2) / 86400000)),
        'endDate': toTestDate(currentDate, 0),
        'wasNotTaken': true,
        'strength': '',
        'frequency': '',
        'additionalInstructions': '',
        'displayName': 'today\'s med (2)',
        'category': 'outpatient'
      },
      {
        'id': 16,
        'medication': 'today\'s med (3)',
        'quantity': '14kg',
        'startDate': toTestDate(currentDate, -1 * ((1000 * 60 * 2) / 86400000)),
        'endDate': null,
        'wasNotTaken': true,
        'strength': '',
        'frequency': '',
        'additionalInstructions': '',
        'displayName': 'today\'s med (3)',
        'category': 'outpatient'
      },
      {
        'id': 17,
        'medication': 'today\'s med (3)',
        'quantity': '14kg',
        'startDate': toTestDate(currentDate, -120),
        'endDate': null,
        'wasNotTaken': true,
        'strength': '',
        'frequency': '',
        'additionalInstructions': '',
        'displayName': 'today\'s med (3)',
        'category': 'outpatient'
      },
      {
        'id': 18,
        'medication': 'today\'s med (3)',
        'quantity': '14kg',
        'startDate': toTestDate(currentDate, -120),
        'endDate': null,
        'wasNotTaken': true,
        'strength': '',
        'frequency': '',
        'additionalInstructions': '',
        'displayName': 'today\'s med (3)',
        'category': 'patientspecified'
      }
    ];

    results = results.filter(function(d) {
      if (d.startDate !== null && (new Date(d.startDate)) >= (new Date(data.end))) {
        return false;
      }
      if (d.endDate !== null && (new Date(d.endDate)) <= (new Date(data.start))) {
        return false;
      }
      return true;
    });

    return new Promise((resolve) => {
      setTimeout(() => resolve({
        httpStatus: new HttpStatus(HttpStatus.STATUS_TYPE.OK),
        data: results
      }), 1);
    });
  }
}
