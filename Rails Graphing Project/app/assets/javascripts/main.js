/**
 * This file is the main entry point in this project.
 * Component level js should be defined in separate files and imported into this file.
 */

// import all stylesheets
import '../stylesheets/main.scss';

// import local and vendor js
import $ from 'jquery';
import { BloodPressureGraph } from './graphs/blood-pressure-graph';
import { MedicationTimelineGraph } from './graphs/medication-timeline-graph';
import { LoggerManager } from './common/managers/logger.manager';
import { KeepAliveManager } from './common/managers/keep-alive.manager';

$(document).ready(function() {
  setTimeout(() => {
    const bloodPressureGraphs = [];
    $('.blood-pressure-container').each((_index, graph) => {
      bloodPressureGraphs.push(new BloodPressureGraph($(graph)));
    });

    const medGraphs = [];
    $('.medication-container').each((_index, graph) => {
      medGraphs.push(new MedicationTimelineGraph($(graph)));
    });

    if ($('.graphs.index').length) {
      bloodPressureGraphs.forEach((graph) => {
        graph.updateGraph($('#date-range')[0].value);
      });
      medGraphs.forEach((graph) => {
        graph.updateGraph($('#date-range')[0].value);
      });
    }

    LoggerManager.logNavigation('ResultsGraphing', 'Visited');

    let keepAliveManager = new KeepAliveManager(KEEP_ALIVE.expireTime);

    $('#date-range').change(event => {
      const options = event.target.options;
      const option = options[options.selectedIndex];
      keepAliveManager.keepAlive().then(() => {
        bloodPressureGraphs.forEach((graph) => {
          graph.updateGraph(option.value);
        });
        medGraphs.forEach((graph) => {
          graph.updateGraph(option.value);
        });
      }, () => {
        bloodPressureGraphs.forEach((graph) => {
          graph.renderError();
        });
        medGraphs.forEach((graph) => {
          graph.renderError();
        });
      });

      LoggerManager.logGraphSelectors('TimeRange', option.text);
    });
  }, 0);
});
