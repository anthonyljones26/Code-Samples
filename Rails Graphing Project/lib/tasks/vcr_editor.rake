require Rails.root.join('spec/helpers/vcr_helper')

namespace :vcr_editor do
  include ResultsGraphingFhir::VcrHelper
  CASSETTES_DIR = 'spec/fixtures/vcr_cassettes'.freeze
  FHIR_DIR = 'spec/fixtures/fhir_data'.freeze
  REGEX = {
    date: /\d{4}-\d{2}-\d{2}/,
    datetime: /\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:Z|(?:[+-]|%2B)\d{2}:?\d{2})/
  }.freeze

  desc 'Edit medications for has_data'
  task :edit_has_data do
    # rake vcr_editor:edit_has_data

    # open files that contain data that we want to put into the vcr cassettes
    med_orders_file = file_read(FHIR_DIR, 'custom/MedicationOrder.json')
    med_statements_file = file_read(FHIR_DIR, 'custom/MedicationStatement.json')

    # find last date in each file to use as a reference point for time travel
    med_orders_reference_date = med_orders_file.scan(REGEX[:date]).uniq.max
    med_statements_reference_date = med_statements_file.scan(REGEX[:date]).uniq.max

    # iterate through time_travel_times and date_range_spec hashes defined in vcr_helper.rb
    time_travel_times.each do |time_key, time_option|
      # next unless time_key == :no_data
      # next unless time_key == :has_data
      # next unless time_key == :modified_data
      # next unless time_key == :extend_year
      # next unless time_key == :home_data

      # get date that we want to time travel to
      date_vcr = time_option.to_date.to_s

      date_range_spec[:options].each do |range_key, _range_option|
        next unless date_range_spec[:options][range_key][:cassette_name].key? time_key

        # setup file names
        cassette_file_name = date_range_spec[:options][range_key][:cassette_name][time_key].ext('.yml')
        cassette_file_name_bak = cassette_file_name.dup.ext("#{Time.now.strftime('%Y%m%dT%H%M%S')}.yml")

        # backup current file
        FileUtils.cp(
          Rails.root.join(CASSETTES_DIR, cassette_file_name),
          Rails.root.join(CASSETTES_DIR, cassette_file_name_bak)
        )

        # create time travel data
        med_orders_time_travel = do_time_travel_string(med_orders_reference_date, date_vcr, med_orders_file)
        med_statements_time_travel = do_time_travel_string(med_statements_reference_date, date_vcr, med_statements_file)

        # open the cassette
        cassette = YAML.load_file(Rails.root.join(CASSETTES_DIR, cassette_file_name))

        # edit the cassette
        cassette['http_interactions'].delete_if do |http_interaction|
          uri = http_interaction['request']['uri']
          action = 'skip'
          if uri.include? '/Observation'
            action = 'skip'
          elsif ['/MedicationStatement', '/MedicationOrder'].any? { |needle| uri.include? needle }
            action = uri.include?('-pageDirection=NEXT') ? 'delete' : 'edit'
          end

          case action
          when 'skip'
            next false
          when 'delete'
            next true
          when 'edit'
            # read the response body
            body = JSON.parse(http_interaction['response']['body']['string'])

            # remove next/previous links
            body['link'].delete_if do |link|
              next true unless link['relation'] == 'self'

              false
            end

            # edit the entry
            if time_key == :no_data
              body.delete('entry')
            else
              body['entry'] = []
              if uri.include? '/MedicationOrder'
                body['entry'] = JSON.parse(med_orders_time_travel)
              elsif uri.include? '/MedicationStatement'
                body['entry'] = JSON.parse(med_statements_time_travel)
              end
              body['entry'].map! { |item| { fullUrl: '', resource: item } }
            end

            # override original response body
            http_interaction['response']['body']['string'] = body.to_json
          end

          # do not delete by returning false
          false
        end

        # save the changes
        file_write(CASSETTES_DIR, cassette_file_name, cassette.to_yaml)
      end
    end
  end

  desc 'Edit dates in a file'
  task :edit_dates, %i[old_date new_date old_file new_file] => :environment do |_t, args|
    # rake vcr_editor:edit_dates['2013-04-26','2013-01-01','custom/blood_pressure/has_data/one_day.yml',
    #  'custom/blood_pressure/modified_data/one_day_cross_year.yml']
    do_time_travel(args[:old_date], args[:new_date], args[:old_file], args[:new_file])
  end

  desc 'Setup various rspec edge cases'
  task :setup_edge_cases do
    # rake vcr_editor:setup_edge_cases

    do_time_travel(
      '2013-04-26',
      '2013-01-01',
      'custom/blood_pressure/has_data/one_day.yml',
      'custom/blood_pressure/modified_data/one_day_cross_year.yml'
    )

    do_time_travel(
      '2013-04-26',
      '2013-01-04',
      'custom/blood_pressure/has_data/one_week.yml',
      'custom/blood_pressure/modified_data/one_week_cross_year.yml'
    )

    do_time_travel(
      '2013-04-26',
      '2013-01-15',
      'custom/blood_pressure/has_data/one_month.yml',
      'custom/blood_pressure/modified_data/one_month_cross_year.yml'
    )

    do_time_travel(
      '2013-04-26',
      '2013-02-01',
      'custom/blood_pressure/has_data/two_months.yml',
      'custom/blood_pressure/modified_data/two_months_cross_year.yml'
    )

    do_time_travel(
      '2013-04-26',
      '2013-03-01',
      'custom/blood_pressure/has_data/six_months.yml',
      'custom/blood_pressure/modified_data/six_months_cross_year.yml'
    )
  end

  def do_time_travel_string(old_date, new_date, data)
    data_modified = data.dup
    date_diff = (new_date.to_date - old_date.to_date).to_i
    dates = data_modified.scan(REGEX[:date]).uniq.sort
    dates.each do |date|
      data_modified.gsub!(date, (date.to_date + date_diff.days).to_s)
    end
    data_modified
  end

  def do_time_travel(old_date, new_date, old_file, new_file)
    cassette = file_read(CASSETTES_DIR, old_file)
    cassette = do_time_travel_string(old_date, new_date, cassette)
    file_write(CASSETTES_DIR, new_file, cassette)
  end

  def file_read(file_dir, file_name)
    File.read(Rails.root.join(file_dir, file_name))
  end

  def file_write(file_dir, file_name, data)
    File.write(Rails.root.join(file_dir, file_name), data)
  end
end
