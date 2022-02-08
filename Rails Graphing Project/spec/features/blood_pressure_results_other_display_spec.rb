require 'rails_helper'

RSpec.feature 'Blood Pressure Other Filter Button' do
  context 'Display button with other data initially' do
    before(:each) do
      setup_session
      visit_root_page(:other_data)
      expect_page_no_errors
    end

    after(:each) do |example|
      CapybaraHelper.take_screenshot(page) unless example.exception
    end

    scenario 'should display for other data' do
      expect(page).to have_selector('.other-bp-checkbox')
    end
    context 'selecting data without other data' do
      scenario 'should hide without other data' do
        visit_root_page(:home_data, mock_data: :mock_no_other_data)
        expect(page).to_not have_selector('.other-bp-checkbox')
      end
    end
  end

  context 'Display button with no other data initially' do
    before(:each) do
      setup_session
      visit_root_page(:home_data, mock_data: :mock_no_other_data)
      expect_page_no_errors
    end

    after(:each) do |example|
      CapybaraHelper.take_screenshot(page) unless example.exception
    end

    scenario 'should hide checkbox for other data' do
      expect(page).to_not have_selector('.other-bp-checkbox')
    end

    context 'selecting data with other data' do
      scenario 'should display checkbox for other data' do
        select_two_years(:has_data)
        select_two_months(:other_data)
        expect(page).to have_selector('.other-bp-checkbox')
      end
    end
  end
end
