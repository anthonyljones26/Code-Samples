/* eslint-disable no-unused-vars */
/**
 * Timekeeper is for testing only.
 */

import $ from 'jquery';
import timekeeper from 'timekeeper';

class TimekeeperForTests {
  timeTravel() {
    let urlVars = this.getUrlParams();
    if (urlVars && urlVars.time_travel) {
      timekeeper.travel(new Date(urlVars.time_travel));
    }
  }

  getUrlParams() {
    let search = window.location.search;
    let hashes = search.slice(search.indexOf('?') + 1).split('&');
    let params = {};
    hashes.map(hash => {
      let [key, val] = hash.split('=');
      params[key] = decodeURIComponent(val);
    });
    return params;
  }
}

$(document).ready(function() {
  (new TimekeeperForTests()).timeTravel();
});
