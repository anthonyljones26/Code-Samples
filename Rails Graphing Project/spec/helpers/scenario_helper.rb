module ResultsGraphingFhir
  module ScenarioHelper
    def expect_page_no_errors
      expect(page).to have_title 'ResultsGraphingFhir'

      within('.blood-pressure-container') do
        expect(page).not_to have_selector('.error-container')
        expect(page).to have_selector('.chart-container')
      end

      within('.medication-container') do
        expect(page).not_to have_selector('.error-container')
        expect(page).to have_selector('.chart-container')
      end
    end

    def expect_blood_pressure_graph
      within('.blood-pressure-container') do
        expect(page).not_to have_selector('.error-container')
        expect(find('.graph-title').text).to eq('Blood Pressure(mmHg)')

        # X-axis represents Date/Time
        expect(page).to have_selector('.d3-axis')
        expect(page).to have_selector('.d3-data')
        expect(page).to have_selector('.mouse-over-effects')
        ticks = find_all('svg#chart g.d3-x-axis g.tick')
        CheckGraph::Ticks.day(ticks)

        # Y-axis represents measurement
        ticks = find_all('svg#chart g.d3-y-axis g.tick')
        CheckGraph::Ticks.bp_measurements(ticks)
      end
    end

    def expect_medication_graph
      within('.medication-container') do
        graph_title = find('.graph-title').text
        expect(page).not_to have_selector('.error-container')
        expect(graph_title).to eq("Medications\nSort By:\nA-Z\nLast Updated\nActive Meds Only Home Meds Only")

        # X-axis represents Date/Time
        expect(page).to have_selector('.d3-axis')
        expect(page).to have_selector('.d3-data')
        expect(page).to have_selector('.mouse-over-effects')
        ticks = find_all('svg.medication-timeline-chart g.d3-x-axis g.tick')
        CheckGraph::Ticks.day(ticks)

        # Y-axis represents measurement
        ticks = find_all('svg.medication-timeline-chart g.d3-y-axis g.tick')
        CheckGraph::Ticks.medication(ticks)
      end
    end

    def expect_graph_options
      expect_date_range_options
      expect(page).to have_checked_field('home-bp-checkbox')
      expect(page).to have_checked_field('office-bp-checkbox')
      expect(page).to have_checked_field('other-bp-checkbox')
      expect(page).to have_checked_field('systolic-checkbox')
      expect(page).to have_checked_field('diastolic-checkbox')
      expect(page).to have_checked_field('normalcy-checkbox')
      expect(page).to have_checked_field('smoothing-checkbox')
    end

    def expect_date_range_options(selected_option = '2 Months') # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      expect(page).to have_select(
        'date-range',
        options: [
          '1 Day',
          '1 Week',
          '1 Month',
          '2 Months',
          '6 Months',
          '1 Year',
          '2 Years'
        ],
        selected: selected_option
      )

      options = find_all('select#date-range option')
      expect(options[0].value).to eq('1')
      expect(options[1].value).to eq('7')
      expect(options[2].value).to eq('30')
      expect(options[3].value).to eq('60')
      expect(options[4].value).to eq('180')
      expect(options[5].value).to eq('365')
      expect(options[6].value).to eq('730')
    end
  end
end
