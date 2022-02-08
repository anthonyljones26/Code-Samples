import $ from 'jquery';
import { HttpStatus } from '../../models/http-status.model';

export class BaseServiceManager {
  constructor() {
    this.REQUEST_METHOD = Object.freeze({
      GET: 'GET',
      POST: 'POST',
      PUT: 'PUT',
      DELETE: 'DELETE'
    });

    this.config = {
      connectionTimeout: 60000 // 60 seconds
    };
  }

  setupHttpHeader(setContentType, setAcceptType, setCSRFToken) {
    const header = {};
    if (setContentType) {
      header['Content-Type'] = 'application/json';
    }

    if (setCSRFToken && document.head.querySelector('[name~=csrf-token][content]')) {
      header['X-CSRF-Token'] = document.head.querySelector('[name~=csrf-token][content]').content;
    }

    if (setAcceptType) {
      header.Accept = 'application/json';
    }
    return header;
  }

  setupHttpGetHeader() {
    return this.setupHttpHeader(false, true, false);
  }

  setupHttpPostHeader() {
    return this.setupHttpHeader(true, true, true);
  }

  setupHttpDeleteHeader() {
    return this.setupHttpHeader(true, true, true);
  }

  executeRequest(method, path, data, header = {}) {
    return $.ajax({
      url: path,
      type: method,
      headers: header,
      dataType: 'json',
      data: data,
      timeout: this.config.connectionTimeout
    }).then((data, textStatus, jqXHR) => {
      return Promise.resolve({
        httpStatus: HttpStatus.fromValue(jqXHR.status),
        data: data
      });
    }).catch((jqXHR, textStatus, errorThrown) => {
      let httpStatus;
      if (textStatus === 'timeout') {
        httpStatus = new HttpStatus(HttpStatus.STATUS_TYPE.REQUEST_TIMEOUT);
      } else {
        httpStatus = HttpStatus.fromValue(jqXHR.status);
      }

      return Promise.reject({
        httpStatus: httpStatus,
        errorThrown: errorThrown
      });
    });
  }

  executeGetRequest(path, data) {
    return this.executeRequest(this.REQUEST_METHOD.GET, path, data, this.setupHttpGetHeader());
  }

  executePostRequest(path, data) {
    return this.executeRequest(this.REQUEST_METHOD.POST, path, JSON.stringify(data), this.setupHttpPostHeader());
  }

  executePutRequest(path, data) {
    return this.executeRequest(this.REQUEST_METHOD.PUT, path, data);
  }

  executeDeleteRequest(path, data) {
    return this.executeRequest(this.REQUEST_METHOD.DELETE, path, data);
  }
}
