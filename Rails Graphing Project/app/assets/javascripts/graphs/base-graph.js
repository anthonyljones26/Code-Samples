import $ from 'jquery';
import * as d3 from 'd3';
import moment from 'moment';
import { LoggerManager } from '.././common/managers/logger.manager';

export class BaseGraph {
  constructor(container) {
    this.name = '';
    this.dateRange = { start: null, end: null };
    this.json = [];
    this.tooltip = {};
    this.lastTooltip = {
      data: null,
      width: null,
      height: null,
      offsetLeft: null
    };
    this.windowHeight = $(window).height();
    this.scrollTop = $(window).scrollTop();

    this.chart = {
      svg: null,
      data: {},
      height: null,
      width: null,
      scale: {
        x: null,
        y: null
      },
      axis: {
        x: null,
        y: null
      },
      container: container
    };

    this.config = {
      axis: {
        x: {
          padding: 0.02
        },
        y: {
          domain: {}
        }
      },
      margin: {
        top: 20,
        right: 20,
        bottom: 50,
        left: 50
      },
      fadeSpeed: 100
    };

    $(window).scroll(() => {
      this.scrollTop = $(window).scrollTop();
    });

    $(window).on("hoverline", (event, xPosition) => {
      this.mouseLinePosition(xPosition);
    });

    $(window).resize(() => {
      this.windowHeight = $(window).height();
      this.resizeGraph();
    });

    this.chart.container.find('.terra-Title').on('click', (event) => {
      const element = $(this.chart.container).find('.graph-title')[0];
      element.classList.toggle('inactive');
      if (element.classList.toggle('active')) {
        LoggerManager.logAccordion(event.currentTarget.textContent, 'Expand');
        this.chart.container.find('.toggle-body').slideDown({
          duration: 'fast', start: () => {
            this.resizeGraph();
          }
        });
      } else {
        LoggerManager.logAccordion(event.currentTarget.textContent, 'Collapse');
        this.chart.container.find('.toggle-body').slideUp('fast');
      }
    });
  }

  updateGraph() {
    // implement in child class
  }

  getDateRange() {
    let startDate,
      endDate;
    endDate = this.dateRange.end ? this.dateRange.end.clone() : moment();

    if (this.dateRange.start) {
      startDate = this.dateRange.start.clone();
    } else {
      let minDate = d3.min(this.json, function(d) {
        if (d.startDate) {
          return d.startDate;
        } else {
          return d.date;
        }
      });

      startDate = (typeof minDate === 'undefined') ? endDate : moment(minDate);
    }
    return {
      start: startDate,
      end: endDate
    };
  }

  updateDateRange(lookBackDays) {
    this.dateRange.start = moment().subtract(lookBackDays, 'days');
    this.dateRange.end = moment();
  }

  updateTicks() {
    let previousValue, currentDate, isMultiYearDateRange, dateRangeDays, formats, formatter;

    previousValue = null;
    currentDate = new Date();
    isMultiYearDateRange = this.isMultiYearDateRange();
    dateRangeDays = this.dateRangeDays();

    formats = {
      hour: d3.timeFormat('%H:%M'),
      day: d3.timeFormat('%b %d'),
      month: d3.timeFormat('%b'),
      year: d3.timeFormat('%Y'),
      withToday: {
        hour: d3.timeFormat('%H:%M|Today')
      },
      withDate: {
        hour: d3.timeFormat('%H:%M|%b %d')
      },
      withYear: {
        day: d3.timeFormat('%b %d|%Y'),
        month: d3.timeFormat('%b|%Y')
      }
    };

    formatter = {
      hour: function(d) {
        let tickValue = '';

        if (previousValue === d.getDate()) {
          tickValue = formats.hour(d);
        } else if (d.getDate() === currentDate.getDate()) {
          tickValue = formats.withToday.hour(d).toUpperCase();
        } else {
          tickValue = formats.withDate.hour(d).toUpperCase();
        }

        previousValue = d.getDate();
        return tickValue;
      },
      day: function(d) {
        let tickValue = '';

        if (!isMultiYearDateRange || previousValue === d.getFullYear()) {
          tickValue = formats.day(d).toUpperCase();
        } else {
          tickValue = formats.withYear.day(d).toUpperCase();
        }

        previousValue = d.getFullYear();
        return tickValue;
      },
      month: function(d) {
        let tickValue = '';

        if (!isMultiYearDateRange || previousValue === d.getFullYear()) {
          tickValue = formats.month(d).toUpperCase();
        } else {
          tickValue = formats.withYear.month(d).toUpperCase();
        }

        previousValue = d.getFullYear();
        return tickValue;
      }
    };

    if (dateRangeDays <= 1) {
      this.chart.axis.x.ticks(d3.timeHour.every(3)).tickFormat(formatter.hour);
    } else if (dateRangeDays <= 7) {
      this.chart.axis.x.ticks(d3.timeDay.every(1)).tickFormat(formatter.day);
    } else if (dateRangeDays <= 31) {
      this.chart.axis.x.ticks(d3.timeDay.every(4)).tickFormat(formatter.day);
    } else if (dateRangeDays <= 61) {
      this.chart.axis.x.ticks(d3.timeWeek.every(1)).tickFormat(formatter.day);
    } else if (dateRangeDays <= 366) {
      this.chart.axis.x.ticks(d3.timeMonth.every(1)).tickFormat(formatter.month);
    } else if (dateRangeDays <= 732) {
      this.chart.axis.x.ticks(d3.timeMonth.every(2)).tickFormat(formatter.month);
    } else if (dateRangeDays <= 1464) {
      this.chart.axis.x.ticks(d3.timeMonth.every(4)).tickFormat(formatter.month);
    } else if (dateRangeDays <= 1830) {
      this.chart.axis.x.ticks(d3.timeMonth.every(6)).tickFormat(formatter.month);
    } else {
      // NOTE: letting d3 handle number of ticks
      this.chart.axis.x.tickFormat(formats.year);
    }
  }

  dateRangeDays() {
    let dateRange = this.getDateRange();
    return dateRange.end.diff(dateRange.start, 'day');
  }

  isMultiYearDateRange() {
    let dateRange = this.getDateRange();
    return !(dateRange.start.isSame(dateRange.end, 'year'));
  }

  formatXAxisTicks(text) {
    text.each(function() {
      let text = d3.select(this),
        words = text.text().split('|').reverse(),
        word,
        lineNumber = 0,
        lineHeight = text.node().getBBox().height,
        y = parseFloat(text.attr("y")),
        dy = parseFloat(text.attr("dy"));

      text.text(null);
      while ((word = words.pop())) {
        text.append("tspan").attr("x", 0).attr("y", y + (lineNumber * lineHeight)).attr("dy", dy + 'em').text(word);
        lineNumber++;
      }
    });
  }

  setupVerticalLine(mouseG) {
    mouseG.append("path") // this is the black vertical line to follow mouse
      .attr("class", "mouse-line")
      .style("stroke", "black")
      .style("stroke-width", "1px")
      .style("opacity", "0");

    mouseG.append('svg:rect') // append a rect to catch mouse movements on canvas
      .attr('width', this.chart.width)
      .attr('height', this.chart.height)
      .attr('fill', 'none')
      .attr('pointer-events', 'all')
      .attr('class', 'mouseover-rect')
      .on('mouseout', function() { // on mouse out hide line, circles and text
        d3.selectAll(".mouse-line")
          .style("opacity", "0");
      })
      .on('mouseover', function() { // on mouse in show line, circles and text
        d3.selectAll(".mouse-line")
          .style("opacity", "1");
      })
      .on('mousemove', () => { // mouse moving over canvas
        let mouse = d3.mouse(this.chart.svg.select(".mouseover-rect").nodes()[0]);
        $(window).trigger("hoverline", [mouse[0]]);
      });
  }

  updateVerticalLine() {
    let mouseGRect = this.chart.svg.select('.mouseover-rect');

    mouseGRect.attr('width', this.chart.width)
      .attr('height', this.chart.height);
  }

  xAxisDomain() {
    let dateRange = this.getDateRange();
    let duration = dateRange.end.diff(dateRange.start, 'milliseconds');
    let timePadding = Math.ceil(duration * this.config.axis.x.padding);
    dateRange.start.subtract(timePadding, 'milliseconds');
    return [dateRange.start, dateRange.end];
  }

  setupChartWidth() {
    const chartDivWidth = this.chart.container.find('.graph-container').width();
    this.chart.width = chartDivWidth - this.config.margin.left - this.config.margin.right;
    this.chart.width = Math.max(this.chart.width, 0);
  }

  setupChartHeight() {
    // implement in child class
  }

  generateTooltip() {
    // implement in child class
  }

  positionTooltip() {
    // implement in child class
  }

  resizeGraph() {
    this.setupChartWidth();
    this.setupChartHeight();
    this.draw();
  }

  redrawAxis() {
    this.updateYAxis();
    this.updateXAxis();
  }

  updateXAxis() {
    let d3Axis = this.chart.svg.select('.d3-axis');
    d3Axis.select(".d3-x-axis")
      .attr('transform', 'translate(0, ' + this.chart.height + ')')
      // .transition()
      .call(this.chart.axis.x);
    d3Axis.selectAll(".d3-x-axis .tick text").call(this.formatXAxisTicks);
  }

  mouseLinePosition(xPosition) {
    if (this.chart.svg !== null) {
      this.chart.svg.select(".mouse-line")
        .attr("d", () => {
          return "M" + xPosition + "," + this.chart.height + " " + xPosition + ",0";
        });
    }
  }

  dateRangeEqual(dateRange) {
    let currentDateRange = this.getDateRange();
    return currentDateRange.start.isSame(dateRange.start) &&
      currentDateRange.end.isSame(dateRange.end);
  }
}
