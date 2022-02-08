require 'rails_helper'

RSpec.feature 'Medication Graph Inpatient Filter' do
  include ResultsGraphingFhir::TooltipHelper
  before(:each) do
    setup_session
    visit_root_page(:has_data)
    select_two_years(:has_data)
    expect_page_no_errors
  end

  after(:each) do |example|
    CapybaraHelper.take_screenshot(page) unless example.exception
  end

  context 'Uncheck inpatient filter' do
    let(:active_header) { ['Medication C', '3 tab(s)'] }
    let(:inactive_header) { ['Medication B', '2 tab(s)'] }
    let(:inpatient_header) { ['Medication A', '1 tab(s)'] }

    before(:each) do
      find('.med-group:nth-of-type(2)').hover
      check_header inactive_header
      check 'filter-inactive-checkbox'
    end

    scenario 'should remove inactive medication' do
      find('.med-group:nth-of-type(2)').hover
      check_header active_header
    end

    scenario 'should remove inpatient and inactive medication' do
      find('.med-group:nth-of-type(1)').hover
      check_header inpatient_header
      check 'filter-inpatient-checkbox'
      find('.med-group:nth-of-type(2)').hover
      check_header active_header
    end

    context 'Check inpatient filter' do
      before(:each) do
        find('.med-group:nth-of-type(2)').hover
        check_header active_header
        uncheck 'filter-inactive-checkbox'
      end
      scenario 'should include inactive medication' do
        find('.med-group:nth-of-type(2)').hover
        check_header inactive_header
      end
    end
  end
end
