import { BaseServiceManager } from "./base.service";

export class KeepAliveServiceManager extends BaseServiceManager {
  constructor() {
    super();
  }

  keepAlive() {
    return this.executeGetRequest(ROUTES.keep_alive, {})
      .then(response => response.httpStatus.isOk() ? Promise.resolve(response) : Promise.reject(response.httpStatus),
        error => Promise.reject(error.httpStatus));
  }
}
