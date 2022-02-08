require 'rails_helper'

RSpec.feature 'Medication Graph Activity Sort' do
  include ResultsGraphingFhir::TooltipHelper
  before(:each) do
    setup_session
    visit_root_page(:has_data)
    expect_page_no_errors
  end

  after(:each) do |example|
    CapybaraHelper.take_screenshot(page) unless example.exception
  end

  let(:alphabetical_header) { ['Medication A', '1 tab(s)'] }
  let(:activity_header) { ['Medication B', '2 tab(s)'] }
  let(:outpatient_header) { ['Medication C', '3 tab(s)'] }

  context('Sort by activity') do
    before(:each) do
      select 'A-Z', from: 'sort-by'
      find('.med-group:nth-of-type(1)').hover
      check_header alphabetical_header

      select 'Last Updated', from: 'sort-by'
    end

    scenario 'should sort medication by activity' do
      find('.med-group:nth-of-type(3)').hover
      check_header activity_header
    end

    scenario ' with home only' do
      find('.med-group:nth-of-type(3)').hover
      check_header activity_header
      check 'filter-inpatient-checkbox'
      find('.med-group:nth-of-type(1)').hover
      check_header outpatient_header
    end
  end

  context 'Sort by Alphabetical' do
    before(:each) do
      select 'Last Updated', from: 'sort-by'
      find('.med-group:nth-of-type(3)').hover
      check_header activity_header
      select 'A-Z', from: 'sort-by'
    end

    scenario 'should sort A-Z' do
      find('.med-group:nth-of-type(1)').hover
      check_header alphabetical_header
    end

    scenario ' with home only' do
      find('.med-group:nth-of-type(1)').hover
      check_header alphabetical_header
      check 'filter-inpatient-checkbox'
      find('.med-group:nth-of-type(1)').hover
      check_header outpatient_header
    end
  end
end
