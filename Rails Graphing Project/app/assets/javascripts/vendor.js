/* eslint-disable no-unused-vars */
/**
 * This file contains references to the vendor libraries we're using in this project. Any files that aren't referenced
 * here will be bundled into main.js for the production build.
 */

// import all stylesheets
import '../stylesheets/vendor.scss';

// import polyfills for legacy browser support
import 'babel-polyfill';

// import all vendor libraries
import $ from 'jquery';
import jQuery from 'jquery';
import * as d3 from 'd3';
import science from 'science';
import moment from 'moment';
import 'cerrner-smart-embeddable-lib/dist/js/cerrner-smart-embeddable-lib-1.0.0.js';
