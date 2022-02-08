require 'rails_helper'

RSpec.feature 'Blood Pressure Graph Tooltip' do
  before(:each) do
    setup_session
    visit_root_page(:has_data)
    expect_page_no_errors
  end

  after(:each) do |example|
    CapybaraHelper.take_screenshot(page) unless example.exception
  end

  scenario 'displays blood pressure chart without tooltip' do
    expect(page).to have_css 'svg.blood-pressure-chart'
    expect(page).not_to have_css '.tooltip.bp-tooltip'
  end

  context 'hover over bp point' do
    scenario 'displays tooltip' do
      find('.systolic-point:nth-of-type(5)').hover
      expect(page.find('.tooltip.bp-tooltip')).to have_content("100/80\nMAR 07, 2013 16:00\nHome")
    end

    scenario 'corresponding diastolic point reacts to systolic point hover' do
      find('.systolic-point:nth-of-type(5)').hover
      expect(page.find('.diastolic-point:nth-of-type(5)')[:class]).to eq('diastolic-point active-point')
    end

    scenario 'corresponding systolic point reacts to diastolic point hover' do
      find('.diastolic-point:nth-of-type(7)').hover
      expect(page.find('.systolic-point:nth-of-type(7)')[:class]).to eq('systolic-point active-point')
    end

    scenario 'un-selected points and lines become more transparent' do
      find('.systolic-point:nth-of-type(5)').hover
      expect(find_all('.active-point').count).to eq(2)
      expect(find_all('.systolic-point:not(.active-point)').count).to eq(12)
      expect(find_all('.diastolic-point:not(.active-point)').count).to eq(12)
    end

    scenario 'three dashes shown if systolic entry is missing' do
      find('.diastolic-point:nth-of-type(4)').hover
      expect(page.find('.tooltip.bp-tooltip')).to have_content("---/60\nMAR 02, 2013 16:00\nHome")
    end

    scenario 'two dashes shown if diastolic entry is missing' do
      find('.systolic-point:nth-of-type(3)').hover
      expect(page.find('.tooltip.bp-tooltip')).to have_content("95/--\nFEB 27, 2013 16:00\nHome")
    end
  end
end
