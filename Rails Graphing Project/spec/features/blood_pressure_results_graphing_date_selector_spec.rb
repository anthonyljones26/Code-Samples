require 'rails_helper'

RSpec.feature 'Blood Pressure Results Graphing Date Selector' do
  before(:each) do
    setup_session
    visit_root_page(:has_data)
    expect_page_no_errors
  end

  after(:each) { |example| CapybaraHelper.take_screenshot(page) unless example.exception }
  context 'click the date selector' do
    before(:each) { find('#date-range').click }
    scenario('display date options') { expect_date_range_options }
  end

  context 'select 2 Years' do
    before(:each) { select_two_years(:has_data) }
    scenario 'update graph with 2 years date range' do
      expect(page).to have_select('date-range', selected: '2 Years')
      expect(page).to have_selector('svg#chart g.d3-axis g.d3-x-axis g.tick', maximum: 13, minimum: 12)
      ticks = find_all('svg#chart g.d3-axis g.d3-x-axis g.tick')
      CheckGraph::Ticks.month(ticks)
    end
  end
end
