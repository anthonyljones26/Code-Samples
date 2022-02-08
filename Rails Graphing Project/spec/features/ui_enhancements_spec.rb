require 'rails_helper'

RSpec.feature 'UI Enhancements' do
  context 'on page load' do
    before(:each) do
      @data_option = :has_data
      @date_range_option = :two_months
      setup_session
    end

    scenario 'shows loading indicators' do
      # NOTE: tagged with do_delay to allow more time to take screenshot of the loading indicators
      # NOTE: setting record to :none due to unnecessary repeated recordings; set to :new_episodes when needed
      VCR.use_cassette(cassette_name(@date_range_option, @data_option), record: :none, tag: :do_delay) do
        visit_with_time_travel(root_path, time_travel_times[@data_option])
        expect(page).to have_selector(
          '.blood-pressure-container .preloader-container, .medication-container .preloader-container'
        )
        CapybaraHelper.take_screenshot(page)
        expect(page).not_to have_selector(
          '.blood-pressure-container .preloader-container, .medication-container .preloader-container'
        )
      end
    end

    context 'select 2 Years' do
      before(:each) do
        @date_range_option = :two_years
        visit_root_page(@data_option)
      end

      scenario 'shows loading indicators' do
        # NOTE: tagged with do_delay to allow more time to take screenshot of the loading indicators
        # NOTE: setting record to :none due to unnecessary repeated recordings; set to :new_episodes when needed
        VCR.use_cassette(cassette_name(@date_range_option, @data_option), record: :none, tag: :do_delay) do
          expect(page).not_to have_selector(
            '.blood-pressure-container .preloader-container, .medication-container .preloader-container'
          )
          select option_text(@date_range_option), from: date_range_spec[:input_name]
          expect(page).to have_selector(
            '.blood-pressure-container .preloader-container, .medication-container .preloader-container'
          )
          CapybaraHelper.take_screenshot(page)
          expect(page).not_to have_selector(
            '.blood-pressure-container .preloader-container, .medication-container .preloader-container'
          )
        end
      end
    end
  end

  context 'has data' do
    before(:each) do
      setup_session
      visit_root_page(:has_data)
      expect_page_no_errors
    end

    after(:each) do |example|
      CapybaraHelper.take_screenshot(page) unless example.exception
    end

    context 'select 2 Years' do
      before(:each) do
        select_two_years(:has_data)
      end

      scenario 'shows truncated medication name' do
        within('svg.medication-timeline-chart g.d3-y-axis g.tick:nth-of-type(6)') do
          text = find('text')
          title = find('text title')
          text_only = text.text.sub(title.text, '')
          expect(text_only).to eq('Medication F - very very long…')
        end
      end

      scenario 'shows full medication name on hover' do
        title = find('svg.medication-timeline-chart g.d3-y-axis g.tick:nth-of-type(6) text title')
        expect(title.text).to eq('Medication F - very very long medication name')

        # NOTE: capybara cannot hover and screenshot the title "tooltip"
      end
    end

    context 'resize window' do
      before(:each) do
        ScreenSize.screen_size 'medium'
      end

      scenario 'shows updated graphs' do
        expect_blood_pressure_graph
        expect_medication_graph
      end

      context 'maximize window' do
        before(:each) do
          ScreenSize.screen_size ScreenSize.default_size
        end

        scenario 'shows updated graphs' do
          expect_blood_pressure_graph
          expect_medication_graph
        end
      end
    end

    scenario 'shows readable graph text' do
      # NOTE: this test is subjective, just get a screenshot for review
    end
  end
end
