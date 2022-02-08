import { BaseServiceManager } from './base.service';
import { BloodPressure } from '../../models/blood-pressure.model';
import { ConvertUtil } from '../../utils/convert.util';
import { HttpStatus } from '../../models/http-status.model';

export class BloodPressureServiceManager extends BaseServiceManager {
  constructor() {
    super();
    this.debug = false;
  }

  getBloodPressure(dateRange) {
    let data = {
      start: ConvertUtil.dateToIsoString(dateRange.start),
      end: ConvertUtil.dateToIsoString(dateRange.end)
    };

    return Promise.resolve()
      .then(() => {
        return (this.debug) ? this.mockData(data) : this.executeGetRequest(ROUTES.graph_data, data);
      })
      .then(response => {
        if (response.httpStatus.isOk()) {
          let results = [], i;
          for (i = response.data.length - 1; i >= 0; i--) {
            results.push(BloodPressure.fromJson(response.data[i]));
          }
          return Promise.resolve(results);
        } else {
          return Promise.reject(response.httpStatus);
        }
      }, error => {
        return Promise.reject(error.httpStatus);
      });
  }

  mockData(dateRange) {
    let results, startDate, endDate, halfDate, i;

    results = [];

    if (dateRange.start) {
      startDate = new Date(dateRange.start);
    } else {
      startDate = new Date();
      startDate.setTime(startDate.getTime() - 10 * 365 * 24 * 60 * 60 * 1000);
    }
    endDate = new Date(dateRange.end);
    halfDate = new Date(startDate.getTime() + ((endDate.getTime() - startDate.getTime()) / 2));

    // test start edge
    results.push({
      date: (new Date(startDate)).toString(),
      source: 'home',
      systolic: 100,
      diastolic: 60,
      sLow: 70,
      sHigh: 110,
      dLow: 35,
      dHigh: 75
    });

    // test end edge
    results.push({
      date: (new Date(endDate)).toString(),
      source: 'home',
      systolic: 110,
      diastolic: 70,
      sLow: 80,
      sHigh: 120,
      dLow: 40,
      dHigh: 85
    });

    // test over max
    // results.push({
    //   date: new Date(halfDate),
    //   source: 'home',
    //   systolic: 220,
    //   diastolic: 220,
    //   sLow: 80,
    //   sHigh: 120,
    //   dLow: 40,
    //   dHigh: 85
    // });

    for (i = 0; i < 10000; i++) {
      let randomTime = Math.floor(Math.random() * (7 * 24 * 60 * 60 * 1000));
      let random = Math.random();
      let randomSourceType;

      startDate = new Date(startDate.getTime() + randomTime);
      if (startDate > endDate) {
        break;
      }

      if (random < 0.1) {
        randomSourceType = 'other';
      } else if (random < 0.3) {
        randomSourceType = 'office';
      } else {
        randomSourceType = 'home';
      }

      let jsonData = {
        date: (new Date(startDate)).toString(),
        source: randomSourceType,
        systolic: 0,
        diastolic: 0,
        dLow: 0,
        dHigh: 0,
        sLow: 0,
        sHigh: 0
      };

      if (startDate > halfDate) {
        jsonData.sLow = 80;
        jsonData.sHigh = 120;
        jsonData.dLow = 40;
        jsonData.dHigh = 85;
      } else {
        jsonData.sLow = 70;
        jsonData.sHigh = 110;
        jsonData.dLow = 35;
        jsonData.dHigh = 75;
      }

      jsonData.systolic = Math.floor(Math.random() * (120 - 75 + 1) + 75);
      jsonData.diastolic = Math.floor(Math.random() * (65 - 35 + 1) + 35);
      results.push(jsonData);
    }

    return new Promise((resolve) => {
      setTimeout(() => resolve({
        httpStatus: new HttpStatus(HttpStatus.STATUS_TYPE.OK),
        data: results
      }), 1);
    });
  }
}
