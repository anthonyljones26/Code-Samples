require 'rails_helper'

RSpec.feature 'Example Feature' do
  # features have global before/after(:all) hooks in capybara_setup for common Capybara setup/teardown routines

  after(:each) do |example|
    CapybaraHelper.take_screenshot(page) unless example.exception
  end

  context 'context here' do
    # features have a global before(:each) hook in screen_size to define the screen size, with default of 'large'
    scenario 'scenario here default' do
      visit '/'
      expect(page).to have_xpath '//body'
      expect(page).to have_css 'body'
      expect(page).to have_content ''
      expect(page).not_to have_content 'foobar'
    end

    # you may define the screen size by adding device_size metadata
    scenario 'scenario here small', device_size: :small do
      visit '/'
      expect(page).to have_content ''
    end

    scenario 'scenario here medium', device_size: :medium do
      visit '/'
      expect(page).to have_content ''
    end

    scenario 'scenario here large', device_size: :large do
      visit '/'
      expect(page).to have_content ''
    end

    scenario 'scenario here xlarge', device_size: :xlarge do
      visit '/'
      expect(page).to have_content ''
    end
  end

  # easy way to reload all VCR data, not a typical test scenario
  context 'load all vcr data' do
    before(:each) do
      setup_session
    end

    scenario 'all data' do
      time_travel_times.each do |time_key, _time_option|
        # next unless time_key == :no_data
        # next unless time_key == :has_data
        # next unless time_key == :modified_data
        # next unless time_key == :extend_year
        # next unless time_key == :home_data

        visit_root_page(time_key)

        date_range_spec[:options].each do |range_key, _range_option|
          next unless date_range_spec[:options][range_key][:cassette_name].key? time_key

          if range_key != :two_months || date_range_spec[:options][:one_day][:cassette_name].key?(time_key)
            # select one day, so subsequent select of two months will do something
            select_one_day(time_key) if range_key == :two_months

            select_date_range(range_key, time_key)
          end
        end
      end
    end
  end
end
