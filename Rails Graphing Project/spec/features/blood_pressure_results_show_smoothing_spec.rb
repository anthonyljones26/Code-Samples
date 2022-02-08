require 'rails_helper'

RSpec.feature 'Blood Pressure Results Show Smoothing' do
  before(:each) do
    setup_session
    visit_root_page(:has_data)
    expect_page_no_errors
  end

  after(:each) do |example|
    CapybaraHelper.take_screenshot(page) unless example.exception
  end

  context 'disable smoothing' do
    before(:each) do
      find_field('smoothing-checkbox').click
    end

    scenario 'does not show smoothing line' do
      expect(page).not_to have_css '.systolic-trend-line'
      expect(page).not_to have_css '.diastolic-trend-line'
    end

    context 'enable smoothing' do
      before(:each) do
        find_field('smoothing-checkbox').click
      end

      scenario 'shows smoothing line' do
        expect(page).to have_css '.systolic-trend-line'
        expect(page).to have_css '.diastolic-trend-line'
      end

      context 'change date range' do
        before(:each) do
          select_two_years(:has_data)
        end

        scenario 'shows smoothing line' do
          expect(page).to have_css '.systolic-trend-line'
          expect(page).to have_css '.diastolic-trend-line'
        end
      end
    end
  end
end
