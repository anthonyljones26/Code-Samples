import { LoggerServiceManager } from './services/logger.service';

export class LoggerManager {
  static get STATUS_TYPE() {
    return {
      SUCCESS: 0,
      FAILURE: 1,
      REQUEST_TIMEOUT: 2,
      NO_DATA: 3
    };
  }

  static logInteraction(eventDomain, eventType, description) {
    let data = {
      EventDomain: eventDomain,
      EventType: eventType,
      Description: description
    };
    return (new LoggerServiceManager().logInteraction(data));
  }

  static logLocation(eventType, description) {
    this.logInteraction('Location', eventType, description);
  }

  static logAccordion(eventType, description) {
    this.logInteraction('Accordion', eventType, description);
  }

  static logGraphSelectors(eventType, description) {
    this.logInteraction('GraphSelectors', eventType, description);
  }

  static logDataType(eventType, description) {
    this.logInteraction('DataType', eventType, description);
  }

  static logRange(eventType, description) {
    this.logInteraction('Range', eventType, description);
  }

  static logTrend(eventType, description) {
    this.logInteraction('Trend', eventType, description);
  }

  static logNavigation(eventType, description) {
    this.logInteraction('Navigation', eventType, description);
  }

  static logFilter(eventType, description) {
    this.logInteraction('Filter', eventType, description);
  }

}
