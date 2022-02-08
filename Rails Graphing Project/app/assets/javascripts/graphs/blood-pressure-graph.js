import $ from 'jquery';
import * as d3 from 'd3';
import science from 'science';
import { BaseGraph } from './base-graph';
import { BloodPressureManager } from '../common/managers/blood-pressure.manager';
import { LoggerManager } from '../common/managers/logger.manager';

export class BloodPressureGraph extends BaseGraph {
  constructor(container) {
    super(container);
    this.name = 'Blood Pressure Graph';

    $.extend(this.config, {
      tooltipOffset: 10
    });

    $.extend(this.chart, {
      line: {
        systolic: null,
        diastolic: null,
        smooth: null
      },
      area: {
        systolic: null,
        diastolic: null
      },
      show: {
        systolic: true,
        diastolic: true,
        normalcy: true,
        smooth: true,
        data: {
          office: true,
          home: true,
          other: true
        }
      }
    });

    this.chart.data = {
      office: [],
      home: [],
      other: []
    };

    $.extend(this.config, {
      aspectRatio: 12 / 3,
      systolic: {
        point: {
          size: 60
        }
      },
      diastolic: {
        point: {
          size: 60
        }
      }
    });

    this.config.axis.y.domain = {
      end: {
        min: 180
      },
      start: {
        max: 40
      }
    };

    this.generate();
  }

  sortByDateAscending(a, b) {
    return a.date - b.date;
  }

  filterSystolicEntry(entry) {
    return entry.systolic !== null;
  }

  filterDiastolicEntry(entry) {
    return entry.diastolic !== null;
  }

  filterSystolicNormalcy(entry) {
    return entry.sLow !== null && entry.sHigh !== null;
  }

  filterDiastolicNormalcy(entry) {
    return entry.dLow !== null && entry.dHigh !== null;
  }

  setupChartData(results) {
    let i, iEnd;

    this.json = results;
    this.chart.data.office = [];
    this.chart.data.home = [];
    this.chart.data.other = [];

    for (i = 0, iEnd = this.json.length; i < iEnd; i++) {
      if (this.json[i].source === 'office') {
        this.chart.data.office.push(this.json[i]);
      } else if (this.json[i].source === 'home') {
        this.chart.data.home.push(this.json[i]);
      } else {
        this.chart.data.other.push(this.json[i]);
      }
    }
    this.displayOther();
  }

  jsonToSystolic() {
    return this.json.filter(this.filterSystolicEntry);
  }

  jsonToDiastolic() {
    return this.json.filter(this.filterDiastolicEntry);
  }

  jsonToNormalcy() {
    let normalcy, dateRange, firstSystolic, firstDiastolic, lastSystolic, lastDiastolic;

    normalcy = [].concat(this.json);
    if (normalcy.length === 0) {
      return normalcy;
    }

    dateRange = this.getPaddedDateRange();

    // find first entries
    firstSystolic = normalcy.find(this.filterSystolicNormalcy);
    firstDiastolic = normalcy.find(this.filterDiastolicNormalcy);

    // reverse, to find last entries
    normalcy.reverse();
    lastSystolic = normalcy.find(this.filterSystolicNormalcy);
    lastDiastolic = normalcy.find(this.filterDiastolicNormalcy);

    // reverse, to original order
    normalcy.reverse();

    // save new entries on date range endpoints
    normalcy.unshift({
      date: dateRange.start,
      sLow: (typeof firstSystolic !== 'undefined') ? firstSystolic.sLow : null,
      sHigh: (typeof firstSystolic !== 'undefined') ? firstSystolic.sHigh : null,
      dLow: (typeof firstDiastolic !== 'undefined') ? firstDiastolic.dLow : null,
      dHigh: (typeof firstDiastolic !== 'undefined') ? firstDiastolic.dHigh : null
    });
    normalcy.push({
      date: dateRange.end,
      sLow: (typeof lastSystolic !== 'undefined') ? lastSystolic.sLow : null,
      sHigh: (typeof lastSystolic !== 'undefined') ? lastSystolic.sHigh : null,
      dLow: (typeof lastDiastolic !== 'undefined') ? lastDiastolic.dLow : null,
      dHigh: (typeof lastDiastolic !== 'undefined') ? lastDiastolic.dHigh : null
    });

    return normalcy;
  }

  getPaddedDateRange() {
    let dateRange = this.getDateRange();
    let duration = dateRange.end.diff(dateRange.start, 'milliseconds');
    let timePadding = Math.ceil(duration * this.config.axis.x.padding);
    dateRange.start.subtract(timePadding, 'milliseconds');

    return dateRange;
  }

  generate() {
    this.setupChartWidth();
    this.setupChartHeight();
    // this.chart.height = 150;
    this.setupAxis();
    this.setupLines();
    this.setupAreas();
    this.setupChangeHandlers();
    this.renderChart();
  }

  setupChartHeight() {
    let chartDiv = this.chart.container.find('.chart-container');
    let chartDivWidth = chartDiv.width();
    let calculatedHeight = chartDivWidth / this.config.aspectRatio;
    let graphSidebarHeight = this.chart.container.find('.graph-sidebar').height();
    let chartDivHeight = Math.max(calculatedHeight, graphSidebarHeight);

    chartDiv.height(chartDivHeight);
    this.chart.height = chartDivHeight - this.config.margin.top - this.config.margin.bottom;
    this.chart.height = Math.max(this.chart.height, 0);
  }

  yAxisDomain() {
    let maxSystolic = d3.max(this.json, function(d) {
      return d.systolic;
    });

    let minDiastolic = d3.min(this.json, function(d) {
      return d.diastolic;
    });

    if (maxSystolic < this.config.axis.y.domain.end.min || (typeof maxSystolic === 'undefined')) {
      maxSystolic = this.config.axis.y.domain.end.min;
    }

    if (minDiastolic > this.config.axis.y.domain.start.max || (typeof minDiastolic === 'undefined')) {
      minDiastolic = this.config.axis.y.domain.start.max;
    }
    return [minDiastolic, maxSystolic];
  }

  setupAxis() {
    this.chart.scale.x = d3.scaleTime()
      .domain(this.xAxisDomain())
      .range([0, this.chart.width]);
    this.chart.axis.x = d3.axisBottom()
      .scale(this.chart.scale.x);

    this.chart.scale.y = d3.scaleLinear()
      .domain(this.yAxisDomain())
      .range([this.chart.height, 0]);
    this.chart.axis.y = d3.axisLeft()
      .scale(this.chart.scale.y);
  }

  setupLines() {
    // line definitions
    this.chart.line.systolic = d3.line()
      .x(d => {
        return this.chart.scale.x(d.date);
      })
      .y(d => {
        return this.chart.scale.y(d.systolic);
      });

    this.chart.line.diastolic = d3.line()
      .x(d => {
        return this.chart.scale.x(d.date);
      })
      .y(d => {
        return this.chart.scale.y(d.diastolic);
      });

    this.chart.line.smooth = d3.line()
      .curve(d3.curveMonotoneX)
      .x(function(d) {
        return d[0];
      })
      .y(function(d) {
        return d[1];
      });
  }

  setupAreas() {
    // area definitions
    this.chart.area.systolic = d3.area()
      .x(d => {
        return this.chart.scale.x(d.date);
      })
      .y0(d => {
        return this.chart.scale.y(d.sLow);
      })
      .y1(d => {
        return this.chart.scale.y(d.sHigh);
      })
      .curve(d3.curveStep);

    this.chart.area.diastolic = d3.area()
      .x(d => {
        return this.chart.scale.x(d.date);
      })
      .y0(d => {
        return this.chart.scale.y(d.dLow);
      })
      .y1(d => {
        return this.chart.scale.y(d.dHigh);
      })
      .curve(d3.curveStep);
  }

  setupChangeHandlers() {
    let self = this;

    self.chart.container.find('.home-bp-checkbox').change(function() {
      self.chart.show.data.home = $(this).prop('checked');
      LoggerManager.logLocation('Home', (self.chart.show.data.home ? "Checked" : "Unchecked"));
      self.draw();
    });

    self.chart.container.find('.office-bp-checkbox').change(function() {
      self.chart.show.data.office = $(this).prop('checked');
      LoggerManager.logLocation('Office', (self.chart.show.data.office ? "Checked" : "Unchecked"));
      self.draw();
    });

    self.chart.container.find('.other-bp-checkbox').change(function() {
      self.chart.show.data.other = $(this).prop('checked');
      LoggerManager.logLocation('Other', (self.chart.show.data.other ? "Checked" : "Unchecked"));
      self.draw();
    });

    self.chart.container.find('.systolic-checkbox').change(function() {
      self.chart.show.systolic = $(this).prop('checked');
      LoggerManager.logDataType('Systolic', (self.chart.show.systolic ? "Checked" : "Unchecked"));
      self.draw();
    });

    self.chart.container.find('.diastolic-checkbox').change(function() {
      self.chart.show.diastolic = $(this).prop('checked');
      LoggerManager.logDataType('Diastolic', (self.chart.show.diastolic ? "Checked" : "Unchecked"));
      self.draw();
    });

    self.chart.container.find('.normalcy-checkbox').change(function() {
      self.chart.show.normalcy = $(this).prop('checked');
      LoggerManager.logRange('GoalRange', (self.chart.show.normalcy ? "Checked" : "Unchecked"));
      self.draw();
    });

    self.chart.container.find('.smoothing-checkbox').change(function() {
      self.chart.show.smooth = $(this).prop('checked');
      LoggerManager.logTrend('Smoothing', (self.chart.show.smooth ? "Checked" : "Unhecked"));
      self.draw();
    });
  }

  renderChart() {
    let d3Main, d3Axis, d3Data, d3Lines, mouseG;

    // find or add svg object
    if (!this.chart.svg) {
      this.chart.svg = d3.select(this.chart.container.find('.chart-container')[0])
        .append('svg')
        .attr('id', 'chart')
        .attr('class', 'blood-pressure-chart')
        .attr('width', this.chart.width + this.config.margin.left + this.config.margin.right)
        .attr('height', this.chart.height + this.config.margin.top + this.config.margin.bottom);
    }

    this.chart.container.find(".tooltip").remove();
    this.tooltip = d3.select(this.chart.container[0]).append("div").attr("class", "tooltip bp-tooltip");

    // clear all elements for redisplay
    this.chart.svg.selectAll("*").remove();

    // create containers for visual elements
    d3Main = this.chart.svg.append("svg:g").attr("class", "d3-main");
    mouseG = d3Main.append("svg:g").attr("class", "mouse-over-effects");
    d3Axis = d3Main.append("svg:g").attr("class", "d3-axis");
    d3Data = d3Main.append("svg:g").attr("class", "d3-data");
    d3Lines = d3Data.append("svg:g").attr("class", "d3-lines");
    d3Data.append("svg:g").attr("class", "d3-areas");

    // apply margins to main container
    d3Main.attr('transform', 'translate(' + this.config.margin.left + ',' + this.config.margin.top + ')');

    // create x-axis
    d3Axis.append("svg:g")
      .attr("class", "d3-x-axis")
      .attr("transform", "translate(0," + (this.chart.height) + ")")
      .call(this.chart.axis.x);
    d3Axis.selectAll(".d3-x-axis .tick text").call(this.formatXAxisTicks);

    // create y-axis
    d3Axis.append("svg:g")
      .attr("class", "d3-y-axis")
      .call(this.chart.axis.y);

    this.setupVerticalLine(mouseG);

    // systolic line
    d3Lines.append('svg:g')
      .attr('class', 'systolic-data');

    // diastolic line
    d3Lines.append('svg:g')
      .attr('class', 'diastolic-data');
  }

  sourceSymbol(d) {
    switch (d.source) {
      case 'office':
        return d3.symbolSquare;
      case 'home':
        return d3.symbolCircle;
      default:
        return d3.symbolTriangle;
    }
  }

  dateMap(d) {
    return this.chart.scale.x(d.date);
  }

  systolicMap(d) {
    return this.chart.scale.y(d.systolic);
  }

  diastolicMap(d) {
    return this.chart.scale.y(d.diastolic);
  }

  smoothWithLoess(d, lineMap) {
    let xValues = d.map(this.dateMap.bind(this));
    let yValues = d.map(lineMap);
    let yValuesSmoothed;
    let bandwidth = 1;
    if (yValues.length) {
      bandwidth = 10 / yValues.length;
    }

    if (bandwidth > 1) {
      bandwidth = 1;
    }

    try {
      let loess = science.stats.loess().bandwidth(bandwidth);
      yValuesSmoothed = loess(xValues, yValues);
      for (let i = yValuesSmoothed.length - 1; i >= 0; i--) {
        if (isNaN(yValuesSmoothed[i])) {
          yValuesSmoothed[i] = yValues[i];
        }
      }
    } catch (err) {
      yValuesSmoothed = yValues;
    }

    return d3.zip(xValues, yValuesSmoothed);
  }

  smoothSystolic(d) {
    return this.smoothWithLoess(d, this.systolicMap.bind(this));
  }

  smoothDiastolic(d) {
    return this.smoothWithLoess(d, this.diastolicMap.bind(this));
  }

  updateGraph(lookBackDays) {
    let errorEl = this.chart.container.find('.error-container'),
      chartEl = this.chart.container.find('.chart-container'),
      preloaderEl = this.chart.container.find('.preloader-container'),
      dateRange;

    preloaderEl.fadeIn(this.config.fadeSpeed);
    errorEl.fadeOut(this.config.fadeSpeed);
    chartEl.fadeOut(this.config.fadeSpeed);

    this.updateDateRange(lookBackDays);
    dateRange = this.getDateRange();

    BloodPressureManager.getBloodPressureEntries(dateRange)
      .then(results => {
        if (this.dateRangeEqual(dateRange)) {
          chartEl.fadeIn(this.config.fadeSpeed);
          this.setupChartData(results);
          this.draw();
          preloaderEl.fadeOut(this.config.fadeSpeed);
        }
      })
      .catch(statusType => {
        if (this.dateRangeEqual(dateRange)) {
          this.setupChartData([]);
          if (statusType === BloodPressureManager.STATUS_TYPE.NO_DATA) {
            errorEl.find('span').text('No Data');
          } else {
            errorEl.find('span').text('An Error Has Occurred');
          }
          preloaderEl.fadeOut(this.config.fadeSpeed);
          errorEl.fadeIn(this.config.fadeSpeed);
        }
      });
  }

  renderError() {
    const errorEl = this.chart.container.find('.error-container'),
      chartEl = this.chart.container.find('.chart-container');

    chartEl.fadeOut(this.config.fadeSpeed);
    errorEl.find('span').text('An Error Has Occurred');
    errorEl.fadeIn(this.config.fadeSpeed);
  }

  refreshSource() {
    let tempJSON = [];
    if (this.chart.show.data.office) {
      tempJSON = tempJSON.concat(this.chart.data.office);
    }
    if (this.chart.show.data.home) {
      tempJSON = tempJSON.concat(this.chart.data.home);
    }
    if (this.chart.show.data.other) {
      tempJSON = tempJSON.concat(this.chart.data.other);
    }

    this.json = tempJSON;
    this.json.sort(this.sortByDateAscending);
  }

  updateYAxis() {
    this.chart.svg.select('g .d3-y-axis')
      .transition()
      .call(this.chart.axis.y);
  }

  generateTooltip(d) {
    let systolic,
      diastolic,
      source,
      date,
      time,
      tooltipHtml;

    systolic = d.systolic === null ? '---' : d.systolic;
    diastolic = d.diastolic === null ? '--' : d.diastolic;
    date = d.date.format('MMM DD, YYYY').toUpperCase();
    source = d.source.charAt(0).toUpperCase() + d.source.slice(1);
    time = d.date.format('HH:mm');
    tooltipHtml = `
      <div class="tooltip-section">
        <table>
          <tr>
            <td class="bp-tooltip-value bp-entry">
              <b>${systolic}<span class="bp-entry-divider">/</span>${diastolic}</b>
            </td>
          </tr>
          <tr>
            <td class="bp-tooltip-value">${date}</td>
            <td class="bp-tooltip-value">${time}</td>
          </tr>
          <tr>
            <td class="bp-tooltip-value">${source}</td>
          </tr>
        </table>
      </div>`;

    return this.tooltip.html(tooltipHtml);
  }

  positionTooltip(node) {
    const rect = node.getBoundingClientRect();
    const nodeX = rect.left + (rect.width / 2);
    const nodeY = rect.top + (rect.height / 2);

    let chartOffsetLeft =  this.chart.container.find('.blood-pressure-chart .d3-x-axis').offset().left,
      windowHeight = this.windowHeight,
      scrollTop = this.scrollTop,
      tooltip = this.chart.container.find('.tooltip'),
      toolTipWidth = tooltip.outerWidth(),
      toolTipHeight = tooltip.outerHeight(),
      toolTipLeft = nodeX - toolTipWidth - this.config.tooltipOffset,
      toolTipTop = nodeY - (toolTipHeight / 2) + scrollTop;

    if (toolTipLeft < chartOffsetLeft) {
      toolTipLeft = nodeX + this.config.tooltipOffset;
    }

    if (toolTipTop < scrollTop) {
      toolTipTop = scrollTop;
    } else if (toolTipTop + toolTipHeight > windowHeight + scrollTop) {
      toolTipTop = windowHeight + scrollTop - toolTipHeight;
    }

    if (toolTipTop < 0) {
      toolTipTop = 0;
    }

    this.tooltip.style('transform', `translate(${toolTipLeft}px, ${toolTipTop}px)`);
    this.tooltip.style('display', 'inline-block');
  }

  draw() {
    this.drawSvg();
    this.refreshSource();
    this.setupAxis();
    this.updateTicks();
    this.updateYAxis();
    this.updateXAxis();
    this.updateVerticalLine();
    this.drawLines();
    this.drawArea();
    this.addBloodPressurePointEvents();
  }

  drawSvg() {
    this.chart.svg
      .attr('width', this.chart.width + this.config.margin.left + this.config.margin.right)
      .attr('height', this.chart.height + this.config.margin.top + this.config.margin.bottom);
  }

  displayOther() {
    if (this.chart.data.other.length) {
      this.chart.container.find('.option-items.other').slideDown('fast');
    } else {
      this.chart.container.find('.option-items.other').slideUp('fast');
    }
  }

  drawLines() {
    this.drawSystolic();
    this.drawDiastolic();
    this.drawTrendLine();
  }

  drawSystolic() {
    let d3Lines = this.chart.svg.select('.systolic-data');

    d3Lines.selectAll('.systolic-line, .systolic-point').remove();
    if (this.chart.show.systolic) {
      let systolicJson = this.jsonToSystolic();
      d3Lines.append('svg:path')
        .attr('d', this.chart.line.systolic(systolicJson))
        .attr('class', 'systolic-line');
      d3Lines.selectAll('dot')
        .data(systolicJson)
        .enter()
        .append('path')
        .attr('class', 'systolic-point')
        .attr('d', d3.symbol().size(this.config.systolic.point.size).type(this.sourceSymbol))
        .attr('transform', d => {
          return 'translate(' + this.chart.scale.x(d.date) + ',' + this.chart.scale.y(d.systolic) + ')';
        });
    }
  }

  drawDiastolic() {
    let d3Lines = this.chart.svg.select('.diastolic-data');

    d3Lines.selectAll('.diastolic-line, .diastolic-point').remove();
    if (this.chart.show.diastolic) {
      let diastolicJson = this.jsonToDiastolic();
      d3Lines.append('svg:path')
        .attr('d', this.chart.line.diastolic(diastolicJson))
        .attr('class', 'diastolic-line');
      d3Lines.selectAll('dot')
        .data(diastolicJson)
        .enter()
        .append('path')
        .attr('class', 'diastolic-point')
        .attr('d', d3.symbol().size(this.config.diastolic.point.size).type(this.sourceSymbol))
        .attr('transform', d => {
          return 'translate(' + this.chart.scale.x(d.date) + ',' + this.chart.scale.y(d.diastolic) + ')';
        });
    }
  }

  drawTrendLine() {
    let diastolicJson = this.jsonToDiastolic();
    let systolicJson = this.jsonToSystolic();
    let d3Lines = this.chart.svg.select('.d3-lines');
    d3Lines.selectAll('.systolic-trend-line, .diastolic-trend-line').remove();
    if (this.chart.show.smooth) {
      d3Lines.append('svg:path')
        .attr('d', this.chart.line.smooth(this.smoothSystolic(systolicJson)))
        .attr('class', 'systolic-trend-line');

      d3Lines.append('svg:path')
        .attr('d', this.chart.line.smooth(this.smoothDiastolic(diastolicJson)))
        .attr('class', 'diastolic-trend-line');
    }
  }

  drawArea() {
    let d3Areas = this.chart.svg.select('.d3-areas');
    d3Areas.selectAll('.systolic-normalcy, .diastolic-normalcy').remove();
    if (this.chart.show.normalcy) {
      let normalcy = this.jsonToNormalcy();

      // systolic normalcy
      d3Areas.append('path')
        .attr('d', this.chart.area.systolic(normalcy.filter(this.filterSystolicNormalcy)))
        .attr('class', 'systolic-normalcy');
      // diastolic normalcy
      d3Areas.append('path')
        .attr('d', this.chart.area.diastolic(normalcy.filter(this.filterDiastolicNormalcy)))
        .attr('class', 'diastolic-normalcy');
    }
  }

  addBloodPressurePointEvents() {
    this.chart.svg.selectAll('.systolic-point, .diastolic-point')
      .on('mousemove', () => {
        let mouse;
        mouse = d3.mouse(this.chart.svg.select(".mouseover-rect").nodes()[0]);
        $(window).trigger('hoverline', [mouse[0]]);
      }).on('mouseout', (d, _i, nodes) => {
        this.tooltip.style('display', 'none');
        d3.selectAll('.mouse-line').style('opacity', '0');
        d3.selectAll(nodes)
          .filter((dMatch) => {
            return d === dMatch;
          })
          .classed('active-point', false);
        this.chart.svg.select('.d3-data').classed('highlighting', false);
      }).on('mouseover', (d, i, nodes) => {
        this.generateTooltip(d);
        this.positionTooltip(nodes[i]);
        d3.selectAll('.mouse-line').style('opacity', '1');
        d3.selectAll(nodes)
          .filter((dMatch) => {
            return d === dMatch;
          })
          .classed('active-point', true);
        this.chart.svg.select('.d3-data').classed('highlighting', true);
      });
  }
}
