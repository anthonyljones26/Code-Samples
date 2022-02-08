require 'rails_helper'

RSpec.feature 'Blood Pressure Results Grouping Non Paired Entries' do
  # features have global before/after(:all) hooks in capybara_setup for common Capybara setup/teardown routines
  before(:each) do
    setup_session
    visit_root_page(:has_data, mock_data: :mock_pair_bp_data)
    expect_page_no_errors
  end

  after(:each) do |example|
    CapybaraHelper.take_screenshot(page) unless example.exception
  end

  context 'hover over bp point' do
    scenario 'displays tooltip' do
      find_all('.systolic-point')[0].hover
      expect(page.find('.tooltip.bp-tooltip')).to have_content("180/63\nMAR 10, 2013 16:00\nHome")
    end

    scenario 'corresponding diastolic point reacts to systolic point hover' do
      find_all('.systolic-point')[0].hover
      expect(page.find_all('.diastolic-point')[0][:class]).to eq('diastolic-point active-point')
    end

    scenario 'displays a non-paired tooltip' do
      find_all('.diastolic-point')[1].hover
      expect(page.find('.tooltip.bp-tooltip')).to have_content("---/73\nMAR 12, 2013 18:00\nHome")
    end
  end
end
