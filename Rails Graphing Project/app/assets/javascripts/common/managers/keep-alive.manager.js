import { KeepAliveServiceManager } from './services/keep-alive.service';
import moment from 'moment';

export class KeepAliveManager {
  constructor(sessionTokenExpireTime) {
    this.expireTime = moment(sessionTokenExpireTime, moment.ISO_8601);
    if (!this.expireTime.isValid()) {
      this.expireTime = moment();
    }
  }

  keepAlive() {
    if (this.expireTime.isSameOrBefore()) {
      return ((new KeepAliveServiceManager).keepAlive())
        .then((response) => {
          this.expireTime = moment(response.data.expireTime);
          if (!this.expireTime.isValid()) {
            this.expireTime = moment();
          }
          return Promise.resolve();
        }, (response) => {
          return Promise.reject(response.httpStatus);
        });
    } else {
      return Promise.resolve();
    }
  }
}
