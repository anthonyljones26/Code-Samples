import $ from 'jquery';
import clone from 'clone';
import * as d3 from 'd3';
import { BaseGraph } from './base-graph';
import { ConvertUtil } from '../common/utils/convert.util';
import { MedicationManager } from '../common/managers/medication.manager';
import { LoggerManager } from '../common/managers/logger.manager';
import moment from 'moment';

export class MedicationTimelineGraph extends BaseGraph {
  constructor(container) {
    super(container);
    this.name = 'Medication Timeline';

    $.extend(this.config, {
      barHeightRatio: (3 / 11),
      barRowHeight: 30,
      yRatio: null,
      minHeight: 50,
      barMinWidth: 4,
      tooltipOffset: 10,
      categories: {
        inpatient: 'Inpatient',
        outpatient: 'Office/Outpatient/ED',
        community: 'Prescribed',
        patientspecified: 'Historical'
      },
      filterCategories: ['inpatient', 'outpatient']
    });

    $.extend(this.chart, {
      labelWidth: null,
      hide: {
        inpatientMeds: false,
        inactiveMeds: false
      },
      sortByName: true
    });

    this.medications = {};
    this.homeMeds = [];
    this.activeMeds = [];
    this.generate();
  }

  generate() {
    this.setupChartWidth();
    this.setupChartHeight();
    this.setupAxis();
    this.setupChangeHandlers();
    this.renderChart();
  }

  setupMedicationObject(results) {

    // Create array to reference for tooltip.
    this.tooltipData = this.createTooltipData(clone(results));

    // Separate entries based on medication name and strength
    let medications = this.createMedicationObj(this.tooltipData);

    //Creates lists of data based off of filter
    this.createFilterWhiteLists(medications);

    // Merge entries with same strength that overlap
    this.mergeStrengthEntries(medications);
    return medications;
  }

  setupChartData(medications) {
    // Convert object back to array to display on graph draw latest end date first
    this.json = this.medicationObjectToArray(medications);
  }

  createFilterWhiteLists(medications) {
    Object.keys(medications).forEach((med) => {
      Object.keys(medications[med]).forEach((strength) => {
        medications[med][strength].forEach((entry) => {
          if (!this.config.filterCategories.includes(entry.category)) {
            this.homeMeds.push(med);
          }
          if (this.isMedicationActive(entry)) {
            this.activeMeds.push(med);
          }
        });
      });
    });
  }

  /*****************************************
    Create array from the response into data
    to be displayed in the tooltip
  *****************************************/
  createTooltipData(results) {
    return this.mergeTooltipEntries(results);
  }

  /*****************************************
    Merge overlapping entries that have same
      - medication name
      - strength
      - quantity
      - frequency
      - compliance
      - additional instructions
  *****************************************/
  mergeTooltipEntries(results) {
    let mergedArray = [];
    results.sort((a, b) => this.sortMedications(a, b, true));

    mergedArray.push(results[0]);
    for (let i = 1; i < results.length; i++) {
      let nextEntry = results[i],
        merged = false;

      for (let j = 0; j < mergedArray.length; j++) {
        let comparedEntry = mergedArray[j];

        if (this.similarEntry(comparedEntry, nextEntry)) {
          if (this.isMedicationOverlapping(nextEntry, comparedEntry)) {
            this.updateEntryDates(comparedEntry, nextEntry);
            merged = true;
            break;
          }
        }
      }

      if (!merged) {
        mergedArray.push(nextEntry);
      }
    }
    return mergedArray;
  }

  similarMedicationName(a, b) {
    if (this.compareCase(a.medication, b.medication)) {
      b.displayName = a.displayName;
      return true;
    } else {
      return false;
    }
  }

  similarStrength(a, b) {
    if (this.compareCase(a.strength, b.strength)) {
      b.strength = a.strength;
      return true;
    } else {
      return false;
    }
  }

  compareCase(a, b) {
    let tempA, tempB;

    if (a === undefined) {
      tempA = undefined;
    } else if (a) {
      tempA = a.toLowerCase();
    }

    if (b === undefined) {
      tempB = undefined;
    } else if (b) {
      tempB = b.toLowerCase();
    }
    return tempA === tempB;
  }

  /*****************************************
    Create an object from the tooltipData array
    to separate each entry by strength
  *****************************************/
  createMedicationObj(tooltipData) {
    let medicationObj = {},
      endDate = null,
      tooltipDataReference = [],
      strengthList = [],
      category = '';

    tooltipData.forEach((entry, index) => {
      tooltipDataReference.unshift(index);
      this.addStrengthToList(entry.strength, strengthList);
      endDate = this.getLatestEndDate(endDate, entry.endDate);
      category = category || entry.category;
      if (index + 1 < tooltipData.length) {
        let nextMedication = tooltipData[index + 1];
        if (this.similarMedicationName(entry, nextMedication)) {
          // If startDate/endDate is the same we can merge the strengths and continue on without pushing a new entry to
          // the medicationObj untill all entries with that startDate/endDate are found then push the new entry
          if (this.sameDateRange(entry, nextMedication)) {
            // Assign merged value to true to display strength in tooltip cards.
            nextMedication.merged = true;
            if (this.config.filterCategories.includes(category)) {
              category = nextMedication.category;
            }
            return;
          }
        }
      }

      let strength = strengthList.join(' + ');
      if (!medicationObj.hasOwnProperty(entry.displayName)) {
        medicationObj[entry.displayName] = {};
      }
      if (!medicationObj[entry.displayName].hasOwnProperty(strength)) {
        medicationObj[entry.displayName][strength] = [];
      }
      medicationObj[entry.displayName][strength].push({
        'medication': entry.medication,
        'startDate': entry.startDate,
        'endDate': endDate,
        'reference': tooltipDataReference,
        'merged': entry.merged || false,
        'category': category
      });
      tooltipDataReference = [];
      strengthList = [];
      endDate = null;
      category = "";
    });

    return medicationObj;
  }

  getLatestEndDate(currentDate, newDate) {
    let nextDate = (newDate || this.dateRange.end).isBefore(this.dateRange.end) ? newDate : this.dateRange.end;
    if (moment.isMoment(currentDate)) {
      return currentDate.isBefore(nextDate) ? nextDate : currentDate;
    }
    return nextDate;
  }

  /*****************************************
    Within each strength, merge entries that overlap.
  *****************************************/
  mergeStrengthEntries(medications) {
    for (let medication in medications) {
      for (let strength in medications[medication]) {
        let strengthCount = medications[medication][strength].length,
          mergedArray = [medications[medication][strength][strengthCount - 1]];

        for (let i = strengthCount - 2; i >= 0; i--) {
          let nextEntry = medications[medication][strength][i],
            merged = false;

          for (let j = mergedArray.length - 1; j >= 0; j--) {
            let comparedEntry = mergedArray[j];

            if (this.isMedicationOverlapping(nextEntry, comparedEntry)) {
              this.updateEntryDates(comparedEntry, nextEntry);
              this.updateEntryReferences(comparedEntry, nextEntry);
              merged = true;
              break;
            }
          }

          if (!merged) {
            mergedArray.push(nextEntry);
          }
        }

        medications[medication][strength] = mergedArray;
      }
    }
  }

  /*****************************************
    Convert medication object back into an array
    for d3 to display
  *****************************************/
  medicationObjectToArray(medications) {
    let array = [];
    let medicationNames = [];
    medicationNames = Object.keys(medications).sort((a, b) => {

      if (this.chart.sortByName) {
        return (a.toLowerCase() < b.toLowerCase()) ? -1 : 1;
      } else {
        return (this.getLastDate(medications[a]).isBefore(this.getLastDate(medications[b]))) ? 1 : -1;
      }
    });
    medicationNames.forEach((medication) => {
      if (this.filterData(medication)) {
        return;
      }

      let curMed = medications[medication];
      for (let strength in curMed) {
        array.push(...curMed[strength].map(entry => ({
          'medication': entry.medication,
          'displayName': medication,
          'strength': strength,
          'reference': entry.reference.sort((a, b) => b - a),
          'startDate': entry.startDate,
          'endDate': entry.endDate,
          'merged': entry.merged,
          'category': entry.category
        })));
      }
    });
    array = array.sort((a, b) => this.sortMedicationGroup(a, b, false));
    return array;
  }

  sortMedicationGroup(a, b, endDateAsc) {
    if (a.displayName !== b.displayName) {
      return 0;
    }

    let endDateA = a.endDate || this.dateRange.end;
    let endDateB = b.endDate || this.dateRange.end;
    if (!(endDateA.isSame(endDateB))) {
      return (((endDateAsc) ? 1 : -1) * (endDateA.diff(endDateB)));
    }

    let startDateA = a.startDate || this.dateRange.start;
    let startDateB = b.startDate || this.dateRange.start;
    if (!(startDateA.isSame(startDateB))) {
      return (startDateA.diff(startDateB));
    }

    let strengthA = (a.strength) ? a.strength.toLowerCase() : '';
    let strengthB = (b.strength) ? b.strength.toLowerCase() : '';
    if (strengthA > strengthB) {
      return -1;
    }
    if (strengthA < strengthB) {
      return 1;
    }
  }

  getLastDate(medicationGroup) {
    let dates = [];
    for (let strength in medicationGroup) {

      dates = dates.concat(medicationGroup[strength].map(function(medication) {
        if (medication.endDate.isValid() && medication.endDate.isBefore(moment(), 'day')) {
          return medication.endDate;
        } else {
          return medication.startDate;
        }
      }));
    }
    return moment.max(dates) || moment(0);
  }

  /*****************************************
    Check if medications are overlapping
  *****************************************/
  isMedicationOverlapping(a, b) {
    let startDateA = a.startDate || this.dateRange.start,
      startDateB = b.startDate || this.dateRange.start,
      endDateA = a.endDate || this.dateRange.end,
      endDateB = b.endDate || this.dateRange.end;

    return startDateA.isBetween(startDateB, endDateB, null, '[]') ||
      endDateA.isBetween(startDateB, endDateB, null, '[]');
  }

  /*****************************************
    Check if medications have same
      - medication name
      - strength
      - quantity
      - frequency
      - compliance
      - addition instructions
  *****************************************/
  similarEntry(a, b) {
    return this.similarMedicationName(a, b) && this.similarStrength(a, b) &&
      this.compareCase(a.quantity, b.quantity) && this.compareCase(a.frequency, b.frequency) &&
      a.wasNotTaken === b.wasNotTaken && this.compareCase(a.additionalInstructions, b.additionalInstructions) &&
      this.compareCase(a.category, b.category);
  }

  updateEntryDates(a, b) {
    let startDateA = a.startDate || this.dateRange.start,
      startDateB = b.startDate || this.dateRange.start,
      endDateA = a.endDate || this.dateRange.end,
      endDateB = b.endDate || this.dateRange.end;

    if (startDateB.isBefore(startDateA)) {
      a.startDate = b.startDate;
    }
    if (endDateA.isBefore(endDateB)) {
      a.endDate = b.endDate;
    }
  }

  updateEntryReferences(comparedEntry, nextEntry) {
    comparedEntry.reference.push(...nextEntry.reference);
  }

  addStrengthToList(strength, strengthList) {
    let displayedStrength = strength === '-1 ' ? '--' : strength;
    if (strengthList.indexOf(displayedStrength) === -1) {
      strengthList.unshift(displayedStrength);
    }
  }

  sameDateRange(a, b) {
    let startDateA = a.startDate.isAfter(this.dateRange.start) ? a.startDate : this.dateRange.start,
      endDateA = (a.endDate || this.dateRange.end).isBefore(this.dateRange.end) ? a.endDate : this.dateRange.end,
      startDateB = b.startDate.isAfter(this.dateRange.start) ? b.startDate : this.dateRange.start,
      endDateB = (b.endDate || this.dateRange.end).isBefore(this.dateRange.end) ? b.endDate : this.dateRange.end;
    return startDateA.isSame(startDateB) && endDateA.isSame(endDateB);
  }

  setupChartHeight() {
    this.chart.height = this.config.barRowHeight * (this.yAxisDomain().length);
    this.chart.height = Math.max(this.chart.height, 0);
  }

  setupChartWidth() {
    super.setupChartWidth();
    this.setupLabelWidth();
    if (this.chart.svg) {
      this.chart.svg.attr('width', this.chart.width + this.chart.labelWidth + this.config.margin.left);
    }
  }

  setupLabelWidth() {
    this.chart.labelWidth = this.chart.container.width() - this.chart.width -
      this.config.margin.right - this.config.margin.left;
  }

  setupAxis() {
    this.chart.scale.x = d3.scaleTime()
      .domain(this.xAxisDomain())
      .range([0, this.chart.width])
      .clamp(true);
    this.chart.axis.x = d3.axisBottom()
      .scale(this.chart.scale.x);

    this.chart.scale.y = d3.scaleBand()
      .domain(this.yAxisDomain())
      .rangeRound([0, this.chart.height])
      .paddingInner(this.config.barHeightRatio);
    this.chart.axis.y = d3.axisRight()
      .scale(this.chart.scale.y)
      .tickFormat(d => {
        return d;
      });
  }

  setupChangeHandlers() {

    let self = this;

    self.chart.container.find('.filter-inpatient-checkbox').change(function() {
      self.chart.hide.inpatientMeds = ($(this).prop('checked'));
      self.setupChartData(self.medications);
      self.draw();
      LoggerManager.logFilter('Home Meds Only', (self.chart.hide.inpatientMeds ? "Checked" : "Unchecked"));
    });

    self.chart.container.find('.sort-by').change(x => {
      self.chart.sortByName = (x.target.value === 'alphabetical');
      self.setupChartData(self.medications);
      self.draw();
      LoggerManager.logFilter('Sort By', (this.chart.sortByName ? "A-Z" : "Last Updated"));
    });

    self.chart.container.find('.filter-inactive-checkbox').change(function() {
      self.chart.hide.inactiveMeds = ($(this).prop('checked'));
      self.setupChartData(self.medications);
      self.draw();
      LoggerManager.logFilter('Active Meds Only', (self.chart.hide.inactiveMeds ? "Checked" : "Unchecked"));
    });
  }

  sortMedications(a, b, endDateAsc) {
    let medA, medB, startDateA, startDateB, endDateA, endDateB, strengthA, strengthB;

    medA = a.displayName.toLowerCase();
    medB = b.displayName.toLowerCase();
    if (medA < medB) {
      return -1;
    }
    if (medA > medB) {
      return 1;
    }

    endDateA = a.endDate || this.dateRange.end;
    endDateB = b.endDate || this.dateRange.end;
    if (endDateA.isBefore(endDateB)) {
      return (endDateAsc) ? -1 : 1;
    }
    if (endDateA.isAfter(endDateB)) {
      return (endDateAsc) ? 1 : -1;
    }

    startDateA = a.startDate || this.dateRange.start;
    startDateB = b.startDate || this.dateRange.start;
    if (startDateA.isBefore(startDateB)) {
      return -1;
    }
    if (startDateA.isAfter(startDateB)) {
      return 1;
    }

    strengthA = (a.strength) ? a.strength.toLowerCase() : '';
    strengthB = (b.strength) ? b.strength.toLowerCase() : '';
    if (strengthA > strengthB) {
      return -1;
    }
    if (strengthA < strengthB) {
      return 1;
    }

    return 0;
  }

  medBarTransform(d) {
    let xScale, yScale, xDomain, xScaleRightEdge;

    xDomain = this.chart.scale.x.domain();
    xScaleRightEdge = this.chart.scale.x(xDomain[1]);
    xScale = this.chart.scale.x((d.startDate !== null) ? d.startDate : xDomain[0]);
    if ((xScale + this.medBarWidth(d)) > xScaleRightEdge) {
      xScale = xScaleRightEdge - this.config.barMinWidth;
    }

    yScale = this.chart.scale.y(d.displayName);

    return 'translate(' + xScale + ',' + yScale + ')';
  }

  medBarHeight() {
    return this.chart.scale.y.bandwidth();
  }

  medBarWidth(d) {
    let xScaleStart, xScaleEnd, barWidth;

    if (d.startDate !== null) {
      xScaleStart = this.chart.scale.x(d.startDate);
    } else {
      let xDomain = this.chart.scale.x.domain();
      xScaleStart = this.chart.scale.x(xDomain[0]);
    }

    if (d.endDate !== null) {
      xScaleEnd = this.chart.scale.x(d.endDate);
    } else {
      let xDomain = this.chart.scale.x.domain();
      xScaleEnd = this.chart.scale.x(xDomain[xDomain.length - 1]);
    }

    barWidth = xScaleEnd - xScaleStart;
    if (barWidth < this.config.barMinWidth) {
      barWidth = this.config.barMinWidth;
    }

    return barWidth;
  }

  yAxisDomain() {
    let indexes = [];
    this.json.forEach(function(value) {
      indexes.push(value.displayName);
    });
    return [...new Set(indexes)];
  }

  renderChart() {
    let d3Main, d3Axis, d3Data, mouseG;

    //find or add svg object
    if (!this.chart.svg) {
      this.chart.svg = d3.select(this.chart.container.find('.chart-container')[0])
        .append('svg')
        .attr('class', 'medication-timeline-chart')
        .attr('width', this.chart.width + this.chart.labelWidth + this.config.margin.left)
        .attr('height', this.chart.height + this.config.margin.top + this.config.margin.bottom);
    }

    this.chart.container.find(".tooltip").remove();
    this.tooltip = d3.select(this.chart.container[0]).append("div").attr("class", "tooltip");

    // clear all elements for redisplay
    this.chart.svg.selectAll("*").remove();

    d3Main = this.chart.svg.append("svg:g")
      .attr("class", "d3-main");
    mouseG = d3Main.append("svg:g").attr("class", "mouse-over-effects");
    d3Axis = d3Main.append("svg:g").attr("class", "d3-axis");
    d3Data = d3Main.append("svg:g").attr("class", "d3-data");

    d3Main.attr('transform', 'translate(' + this.config.margin.left + ',' + this.config.margin.top + ')');

    d3Data.append('g')
      .attr('class', 'medication-timeline');

    // create x-axis
    d3Axis.append('g')
      .attr('class', 'd3-x-axis')
      .attr('transform', 'translate(0, ' + this.chart.height + ')')
      .call(this.chart.axis.x);
    d3Axis.selectAll(".d3-x-axis .tick text").call(this.formatXAxisTicks);

    //create y-axis
    d3Axis.append('g').attr('class', 'd3-y-axis')
      .attr('transform', 'translate(' + this.chart.width + ', 0)')
      .call(this.chart.axis.y);
    d3Axis.selectAll(".d3-y-axis .tick text").call(text => {
      this.formatYAxisTicks(text);
    });

    this.setupVerticalLine(mouseG);
  }

  formatYAxisTicks(text) {
    let labelWidth = this.chart.labelWidth;
    text.each(function() {
      let text = d3.select(this),
        fullText = text.text(),
        words = text.text().split(' ').reverse(),
        word,
        width = text.node().getBBox().width,
        previousString = '';
      if (labelWidth < width) {
        text.text(null);

        while ((word = words.pop())) {
          previousString = text.text() || '…';
          text.text(previousString.slice(0, previousString.length - 1) + ' ' +
            word + previousString.slice(previousString.length - 1)); // Insert new word before ellipsis
          if (labelWidth < text.node().getBBox().width) {
            text.text(previousString);
            break;
          }
        }
      }
      text.append("title").text(fullText);
    });
  }

  updateYAxis() {
    let yAxis = this.chart.svg.select('.d3-axis');
    yAxis.select(".d3-y-axis")
      .attr('transform', 'translate(' + (this.chart.width) + ', 0)')
      .call(this.chart.axis.y);
    yAxis.selectAll(".tick text").call(text => {
      this.formatYAxisTicks(text);
    });
  }

  generateTooltip(d) {
    let medication,
      strength,
      reference,
      quantity,
      frequency,
      additionalInstructions,
      category,
      compliance,
      startDate,
      endDate,
      tooltipHtml,
      tooltipData;

    if (this.lastTooltip.data === d) {
      return;
    }

    this.lastTooltip.data = d;
    this.lastTooltip.width = null;
    this.lastTooltip.height = null;
    this.lastTooltip.offsetLeft = null;

    medication = (d.medication) ? d.medication : '--';
    strength = (d.strength) ? d.strength : '--';
    reference = (d.reference) ? d.reference : [];
    tooltipData = this.tooltipData;

    tooltipHtml = `
      <div class="tooltip-section tooltip-header">
        <table class="tooltip-table">
          <tr>
            <th class="tooltip-label">Name</th>
            <td class="tooltip-value"> ${medication} </td>
          </tr>
          <tr>
            <th class="tooltip-label">Strength</th>
            <td class="tooltip-value">${strength}</td>
          </tr>
        </table>
      </div>
      <div class="tooltip-info">`;

    reference.forEach((index) => {
      let data = tooltipData[index];

      strength = (data.strength !== '-1 ') ? data.strength : '--';
      quantity = (data.quantity && data.quantity !== '-1 ') ? data.quantity : '--';
      frequency = (data.frequency) ? data.frequency : '--';
      compliance = (data.wasNotTaken === null) ? '--' : (data.wasNotTaken) ? 'Not Taking' : 'Taking';
      additionalInstructions = (data.additionalInstructions) ? data.additionalInstructions : '--';
      startDate = (data.startDate === null) ? '--' : ConvertUtil.dateToLocaleString(data.startDate);
      endDate = (data.endDate === null) ? '--' : ConvertUtil.dateToLocaleString(data.endDate);
      category = (data.category) ? this.config.categories[data.category] : '--';
      tooltipHtml +=
        `<div class="tooltip-section tooltip-entry">
          <table class="tooltip-table">`;

      if (d.merged) {
        tooltipHtml += `
            <tr>
              <th class="tooltip-label">Strength</th>
              <td class="tooltip-value">${strength}</td>
            </tr>`;
      }

      tooltipHtml += `
            <tr>
              <th class="tooltip-label">Start Date</th>
              <td class="tooltip-value">${startDate}</td>
            </tr>
            <tr>
              <th class="tooltip-label">End Date</th>
              <td class="tooltip-value">${endDate}</td>
            </tr>
            <tr>
              <th class="tooltip-label">Quantity</th>
              <td class="tooltip-value">${quantity}</td>
            </tr>
            <tr>
              <th class="tooltip-label">Frequency</th>
              <td class="tooltip-value">${frequency}</td>
            </tr>
            <tr>
              <th class="tooltip-label">Compliance</th>
              <td class="tooltip-value">${compliance}</td>
            </tr>
            <tr>
              <th class="tooltip-label">Category</th>
              <td class="tooltip-value">${category}</td>
            </tr>
            <tr>
              <th class="tooltip-label">Additional Instructions</th>
              <td class="tooltip-value">${additionalInstructions}</td>
            </tr>
          </table>
        </div>`;
    });

    tooltipHtml += '</div>';

    return this.tooltip.html(tooltipHtml);
  }

  positionTooltip() {
    this.lastTooltip.width = this.lastTooltip.width || this.chart.container.find('.tooltip').outerWidth();
    this.lastTooltip.height = this.lastTooltip.height || this.chart.container.find('.tooltip').outerHeight();
    this.lastTooltip.offsetLeft = this.lastTooltip.offsetLeft ||
      this.chart.container.find('.medication-timeline-chart .d3-x-axis').offset().left;

    let windowHeight = this.windowHeight,
      scrollTop = this.scrollTop,
      chartOffsetLeft = this.lastTooltip.offsetLeft,
      toolTipWidth = this.lastTooltip.width,
      toolTipHeight = this.lastTooltip.height,
      toolTipLeft = d3.event.pageX - toolTipWidth - this.config.tooltipOffset,
      toolTipTop = d3.event.pageY - (toolTipHeight / 2);

    if (toolTipLeft < chartOffsetLeft) {
      toolTipLeft = d3.event.pageX + this.config.tooltipOffset;
    }

    if (toolTipTop < scrollTop) {
      let documentHeight = $(document).height();
      toolTipTop = scrollTop;
      if (toolTipTop + toolTipHeight > documentHeight) {
        toolTipTop = documentHeight - toolTipHeight;
      }
    } else if (toolTipTop + toolTipHeight > windowHeight + scrollTop) {
      toolTipTop = windowHeight + scrollTop - toolTipHeight;
    }

    if (toolTipTop < 0) {
      toolTipTop = 0;
    }

    this.tooltip.style('transform', `translate(${toolTipLeft}px, ${toolTipTop}px)`);
    this.tooltip.style('display', 'inline-block');
  }

  updateGraph(lookBackDays) {
    let errorEl = this.chart.container.find('.error-container'),
      timelineEl = this.chart.container.find('.chart-container'),
      preloaderEl = this.chart.container.find('.preloader-container'),
      dateRange;

    preloaderEl.fadeIn(this.config.fadeSpeed);
    errorEl.fadeOut(this.config.fadeSpeed);
    timelineEl.fadeOut(this.config.fadeSpeed);

    this.updateDateRange(lookBackDays);
    dateRange = this.getDateRange();
    MedicationManager.getMedicationEntries(dateRange)
      .then(results => {
        if (this.dateRangeEqual(dateRange)) {
          timelineEl.fadeIn(this.config.fadeSpeed);
          this.medications = this.setupMedicationObject(results);
          this.setupChartData(this.medications);
          this.draw();
          preloaderEl.fadeOut(this.config.fadeSpeed);
        }
      })
      .catch(statusType => {
        if (this.dateRangeEqual(dateRange)) {
          preloaderEl.fadeOut(this.config.fadeSpeed);
          if (statusType === MedicationManager.STATUS_TYPE.NO_DATA) {
            errorEl.find('span').text('No Data');
          } else {
            errorEl.find('span').text('An Error Has Occurred');
          }
          errorEl.fadeIn(this.config.fadeSpeed);
        }
      });
  }

  renderError() {
    let errorEl = this.chart.container.find('.error-container'),
      timelineEl = this.chart.container.find('.chart-container');

    timelineEl.fadeOut(this.config.fadeSpeed);
    errorEl.find('span').text('An Error Has Occurred');
    errorEl.fadeIn(this.config.fadeSpeed);
  }

  isMedicationActive(medication) {
    return ((medication.endDate || this.dateRange.end).isSameOrAfter(moment(), 'day'));
  }

  filterData(medication) {
    return ((this.chart.hide.inactiveMeds && !this.activeMeds.includes(medication)) ||
      (this.chart.hide.inpatientMeds && !this.homeMeds.includes(medication)));
  }

  draw() {
    this.setupChartWidth();
    this.setupChartHeight();
    this.setupAxis();
    this.updateTicks();
    this.updateYAxis();
    this.updateXAxis();
    this.updateVerticalLine();
    d3.select(this.chart.container.find('.medication-timeline-chart')[0])
      .attr('height', this.chart.height + this.config.margin.top + this.config.margin.bottom);
    this.drawMedicationBars();
  }

  drawMedicationBars() {
    let graph = this.chart.svg.select('.medication-timeline').selectAll('.med-group')
      .data(this.json, function(d) {
        return d;
      });
    this.enterMedicationBars(graph);
    this.exitMedicationBars(graph);
    this.updateMedicationBars(graph);
  }

  exitMedicationBars(medicationBars) {
    medicationBars.exit()
      .style('opacity', 0)
      .remove();
  }

  updateMedicationBars(medicationBars) {
    medicationBars.attr('data-med-name', d => encodeURIComponent(d.medication));
    medicationBars.select('.med-bar')
      .attr('transform', d => this.medBarTransform(d))
      .attr('height', this.medBarHeight())
      .attr('width', d => this.medBarWidth(d));
    this.checkMedicationBarLabels();
  }

  enterMedicationBars(medicationBars) {
    let medGroup;

    this.chart.svg.selectAll('.med-bar-label').remove();
    medGroup = medicationBars.enter()
      .append('g')
      .attr('class', 'med-group')
      .attr('data-med-name', d => encodeURIComponent(d.medication));
    medGroup.append('rect')
      .attr('class', 'med-bar')
      .attr('transform', d => this.medBarTransform(d))
      .attr('height', this.medBarHeight())
      .attr('width', d => this.medBarWidth(d))
      .attr('rx', 7)
      .on('mousemove', d => {
        let mouse;
        this.positionTooltip();
        this.chart.svg.selectAll('.med-group[data-med-name="' + encodeURIComponent(d.medication) + '"]')
          .classed('med-group-inactive', a => {
            return a !== d;
          });
        mouse = d3.mouse(this.chart.svg.select(".mouseover-rect").nodes()[0]);
        $(window).trigger('hoverline', [mouse[0]]);
      }).on('mouseout', () => {
        this.tooltip.style('display', 'none');
        d3.selectAll('.mouse-line').style('opacity', '0');
        this.chart.svg.selectAll('.med-group-inactive').classed('med-group-inactive', false);
      }).on('mouseover', d => {
        this.generateTooltip(d);
        d3.selectAll('.mouse-line').style('opacity', '1');
      });

    this.chart.svg.selectAll('.med-group').append('text')
      .attr('class', 'med-bar-label')
      .attr('transform', d => this.medBarStrengthTransform(d))
      .text(d => d.strength);
  }

  checkMedicationBarLabels() {
    this.chart.svg.selectAll('.med-group').each(function() {
      let medGroup = d3.select(this),
        text = medGroup.select('text'),
        width = medGroup.select('text').node().getBBox().width,
        rectWidth = medGroup.select('rect').node().getBBox().width;

      if (width > rectWidth) {
        text.text('');
      }
    });
  }

  medBarStrengthTransform(d) {
    let xScale, yScale, xDomain, xPos;

    xDomain = this.chart.scale.x.domain();
    xScale = this.chart.scale.x((d.startDate !== null) ? d.startDate : xDomain[0]);
    xPos = xScale + this.medBarWidth(d) - this.config.barMinWidth;
    yScale = (this.chart.scale.y(d.displayName) || 0) + (this.medBarHeight() * 0.75);

    return 'translate(' + xPos + ',' + yScale + ')';
  }
}
