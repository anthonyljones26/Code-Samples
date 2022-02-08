require 'rails_helper'
include ResultsGraphingFhir::TooltipHelper # rubocop:disable Style/MixinUsage #Cannot put include in feature

RSpec.feature 'Medication Graph Inpatient Filter' do
  before(:each) do
    setup_session
    visit_root_page(:has_data)
    expect_page_no_errors
  end

  after(:each) do |example|
    CapybaraHelper.take_screenshot(page) unless example.exception
  end

  context 'Uncheck inpatient filter' do
    let(:outpatient_header) { ['Medication C', '3 tab(s)'] }
    let(:inpatient_header) { ['Medication A', '1 tab(s)'] }
    let(:inpatient_body) do
      [
        '1 tab(s)', # Strength
        'APR 26, 2011', # Start Date
        'APR 26, 2013', # End Date
        '1 tab(s)', # Quantity
        'code text', # Frequency
        'Taking', # Compliance
        'Inpatient', # Category
        '--' # Additional Instructions
      ]
    end
    before(:each) do
      find('.med-group:nth-of-type(1)').hover
      check_header inpatient_header

      check_entry inpatient_body, ['Strength'].concat(TOOLTIP_LABELS)
      check 'filter-inpatient-checkbox'
    end
    scenario 'should remove inpatient medication' do
      find('.med-group:nth-of-type(1)').hover
      check_header outpatient_header
    end

    context 'Check inpatient filter' do
      before(:each) do
        find('.med-group:nth-of-type(1)').hover
        check_header outpatient_header
        uncheck 'filter-inpatient-checkbox'
      end
      scenario 'should include inpatient medication' do
        find('.med-group:nth-of-type(1)').hover
        check_header inpatient_header
      end
    end
  end
end
