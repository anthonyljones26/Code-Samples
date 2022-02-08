import { BaseServiceManager } from "./base.service";
export class LoggerServiceManager extends BaseServiceManager {
  constructor() {
    super();
    this.debug = false;
  }

  logInteraction(data) {
    return this.executePostRequest(ROUTES.log_data, data)
      .then(response => {
        if (response.httpStatus.isCreated()) {
          return Promise.resolve();
        } else {
          return Promise.reject(response.httpStatus);
        }
      }, error => {
        return Promise.reject(error.httpStatus);
      });
  }
}
