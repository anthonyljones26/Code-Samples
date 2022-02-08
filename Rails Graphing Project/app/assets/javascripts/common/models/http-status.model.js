export class HttpStatus {
  static get STATUS_TYPE() {
    return {
      OK: 200,
      NO_CONTENT: 204,
      BAD_REQUEST: 400,
      UNAUTHORIZED: 401,
      NOT_FOUND: 404,
      REQUEST_TIMEOUT: 408,
      INTERNAL_SERVER_ERROR: 500,
      UNKNOWN: 0
    };
  }

  static fromValue(value) {
    for (var key in HttpStatus.STATUS_TYPE) {
      if (HttpStatus.STATUS_TYPE.hasOwnProperty(key)) {
        if (value === HttpStatus.STATUS_TYPE[key]) {
          return new HttpStatus(HttpStatus.STATUS_TYPE[key]);
        }
      }
    }

    return new HttpStatus(HttpStatus.STATUS_TYPE.UNKNOWN);
  }

  constructor(value) {
    this.value = value;
  }

  isOk() {
    return this.value === HttpStatus.STATUS_TYPE.OK;
  }

  isNoContent() {
    return this.value === HttpStatus.STATUS_TYPE.NO_CONTENT;
  }

  isBadRequest() {
    return this.value === HttpStatus.STATUS_TYPE.BAD_REQUEST;
  }

  isUnauthorized() {
    return this.value === HttpStatus.STATUS_TYPE.UNAUTHORIZED;
  }

  isNotFound() {
    return this.value === HttpStatus.STATUS_TYPE.NOT_FOUND;
  }

  isRequestTimeout() {
    return this.value === HttpStatus.STATUS_TYPE.REQUEST_TIMEOUT;
  }

  isInternalServerError() {
    return this.value === HttpStatus.STATUS_TYPE.INTERNAL_SERVER_ERROR;
  }
}
