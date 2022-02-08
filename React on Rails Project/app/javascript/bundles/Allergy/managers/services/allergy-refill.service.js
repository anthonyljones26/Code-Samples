import TideServices from 'tide-services';
import { HttpStatus } from '../../models/http-status.model';

export class AllergyRefillServiceManager {

  static saveRefill(data) {
    return Promise.resolve()
      .then(() => {
        return TideServices.executePostRequest(
          window.tide.config.urls.allergyRefillUrl,
          data,
          { Authorization: 'Bearer ' + window.tide.dex.bcsToken }
        );
      })
      .then(response => {
        if (HttpStatus.fromValue(response.status).isCreated()) {
          response.data = JSON.parse(response.body);
          return Promise.resolve(response);
        } else {
          return Promise.reject(HttpStatus.fromValue(response.status));
        }
      }, error => {
        return Promise.reject(HttpStatus.fromValue(error.status));
      });
  }
}
