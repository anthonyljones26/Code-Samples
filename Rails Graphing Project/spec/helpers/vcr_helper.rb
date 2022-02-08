module ResultsGraphingFhir
  module VcrHelper # rubocop:disable Metrics/ModuleLength
    def time_travel_times
      {
        has_data: '2013-04-26T16:00:00+00:00'.to_datetime,
        modified_data: '2013-04-26T16:00:00+00:00'.to_datetime,
        extend_year: '2016-01-03T12:00:00+00:00'.to_datetime,
        no_data: '2000-01-01T00:00:00+00:00'.to_datetime,
        home_data: '2013-04-26T16:00:00+00:00'.to_datetime,
        other_data: '2013-04-26T16:00:00+00:00'.to_datetime
      }
    end

    def date_range_spec # rubocop:disable Metrics/MethodLength
      {
        input_name: 'date-range',
        options: {
          one_day: {
            option_text: '1 Day',
            cassette_name: {
              has_data: 'custom/blood_pressure/has_data/one_day',
              no_data: 'custom/blood_pressure/no_data/one_day'
            }
          },
          one_week: {
            option_text: '1 Week',
            cassette_name: {
              has_data: 'custom/blood_pressure/has_data/one_week',
              extend_year: 'custom/blood_pressure/extends_year/one_week',
              no_data: 'custom/blood_pressure/no_data/one_week'
            }
          },
          one_month: {
            option_text: '1 Month',
            cassette_name: {
              has_data: 'custom/blood_pressure/has_data/one_month',
              extend_year: 'custom/blood_pressure/extends_year/one_month',
              no_data: 'custom/blood_pressure/no_data/one_month'
            }
          },
          two_months: {
            option_text: '2 Months',
            cassette_name: {
              has_data: 'custom/blood_pressure/has_data/two_months',
              modified_data: 'custom/blood_pressure/modified_data/two_months',
              extend_year: 'custom/blood_pressure/extends_year/two_months',
              no_data: 'custom/blood_pressure/no_data/two_months',
              home_data: 'custom/blood_pressure/custom_sources/two_months',
              other_data: 'custom/blood_pressure/other_data/two_months'
            }
          },
          six_months: {
            option_text: '6 Months',
            cassette_name: {
              has_data: 'custom/blood_pressure/has_data/six_months',
              no_data: 'custom/blood_pressure/no_data/six_months'
            }
          },
          one_year: {
            option_text: '1 Year',
            cassette_name: {
              has_data: 'custom/blood_pressure/has_data/one_year',
              no_data: 'custom/blood_pressure/no_data/one_year'
            }
          },
          two_years: {
            option_text: '2 Years',
            cassette_name: {
              has_data: 'custom/blood_pressure/has_data/two_years',
              no_data: 'custom/blood_pressure/no_data/two_years',
              modified_data: 'custom/blood_pressure/modified_data/two_years',
              other_data: 'custom/blood_pressure/other_data/two_years'
            }
          }
        }
      }
    end

    def option_text(date_range_option)
      date_range_spec[:options][date_range_option][:option_text]
    end

    def cassette_name(date_range_option, data_option)
      date_range_spec[:options][date_range_option][:cassette_name][data_option]
    end

    def visit_root_page(data_option, is_expanded_med: true, is_expanded_bp: true, mock_data: :mock_factory_data)
      loading_classes = []
      # NOTE: setting record to :none due to unnecessary repeated recordings; set to :new_episodes when needed
      VCR.use_cassette(cassette_name(:two_months, data_option), record: :none, allow_playback_repeats: true) do
        visit_with_time_travel(root_path, time_travel_times[data_option], mock_data)
        loading_classes.push('.medication-container .preloader-container') if is_expanded_med
        loading_classes.push('.blood-pressure-container .preloader-container') if is_expanded_bp
        unless loading_classes.empty?
          loading_classes = loading_classes.join(', ')
          expect(page).to have_selector(
            loading_classes
          )
          expect(page).not_to have_selector(
            loading_classes
          )
        end
      end
    end

    def select_date_range(date_range_option, data_option)
      mock_observation_data(date_range_option, data_option)
      # NOTE: setting record to :none due to unnecessary repeated recordings; set to :new_episodes when needed
      VCR.use_cassette(cassette_name(date_range_option, data_option), record: :none, allow_playback_repeats: true) do
        expect(page).not_to have_selector(
          '.blood-pressure-container .preloader-container, .medication-container .preloader-container'
        )
        select option_text(date_range_option), from: date_range_spec[:input_name]
        expect(page).to have_selector(
          '.blood-pressure-container .preloader-container, .medication-container .preloader-container'
        )
        expect(page).not_to have_selector(
          '.blood-pressure-container .preloader-container, .medication-container .preloader-container'
        )
      end
    end

    def select_one_day(data_option)
      select_date_range(:one_day, data_option)
    end

    def select_one_week(data_option)
      select_date_range(:one_week, data_option)
    end

    def select_one_month(data_option)
      select_date_range(:one_month, data_option)
    end

    def select_two_months(data_option)
      select_date_range(:two_months, data_option)
    end

    def select_six_months(data_option)
      select_date_range(:six_months, data_option)
    end

    def select_one_year(data_option)
      select_date_range(:one_year, data_option)
    end

    def select_two_years(data_option)
      select_date_range(:two_years, data_option)
    end
  end
end
