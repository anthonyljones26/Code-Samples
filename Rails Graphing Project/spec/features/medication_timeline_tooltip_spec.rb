require 'rails_helper'

RSpec.feature 'Medication Graph Tooltip' do
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

  scenario 'displays timeline without tooltip' do
    expect(page).to have_css 'svg.medication-timeline-chart'
    expect(page).not_to have_css '.tooltip-table'
  end

  context 'hover over bar with partial info' do
    scenario 'displays tooltip' do
      find('.med-group:nth-of-type(10)').hover
      header_values = [
        'Medication H',
        '--'
      ]
      check_header header_values

      expected_values = [
        '--', # Start Date
        '--', # End Date
        '--', # Quantity
        '--', # Frequency
        '--', # Compliance
        '--', # Category
        '--'  # Additional Instructions
      ]
      check_entry expected_values
    end
  end

  context 'hover over bar with full info' do
    scenario 'displays tooltip with additional instructions' do
      find('.med-group:nth-of-type(3)').hover
      header_values = [
        'Medication C',
        '3 tab(s)'
      ]
      check_header header_values

      expected_values = [
        'FEB 26, 2013', # Start Date
        'APR 26, 2013', # End Date
        '3 tab(s)', # Quantity
        'code text', # Frequency
        'Taking', # Compliance
        'Historical', # Category
        'Testing additional information, thank you for reading this' # Additional Instructions
      ]
      check_entry expected_values
    end
  end

  context 'hover over bar with merged entries' do
    context 'same strength entries' do
      scenario 'displays tooltip with additional entries sorted by start date, latest first' do
        find('.med-group:nth-of-type(11)').hover
        header_values = [
          'Medication I',
          '10 tab(s)'
        ]
        check_header header_values

        expected_values = [
          'MAR 22, 2012', # Start Date
          'APR 25, 2013', # End Date
          '10 tab(s)', # Quantity
          'code text', # Frequency
          'Taking', # Compliance
          'Inpatient', # Category
          '--' # Additional Instructions
        ]

        check_entry expected_values

        last_start_date = expected_values[0].to_datetime

        (2..find_all('.tooltip-entry').count).each do |n|
          within(".tooltip-entry:nth-of-type(#{n})") do
            check_tooltip find_all('.tooltip-label'), TOOLTIP_LABELS
            current_start_date = find_all('.tooltip-value')[0].text.to_datetime
            expect(last_start_date).to be > current_start_date
            last_start_date = current_start_date
          end
        end
      end
    end

    context 'different strength entries' do
      scenario 'displays tooltip with separate entries for each strength, latest first' do
        find('.med-group:nth-of-type(12)').hover
        header_values = [
          'Medication J',
          '2 tab(s) + 1 tab(s)'
        ]
        check_header header_values

        strength_tooltip_labels = ['Strength'].concat(TOOLTIP_LABELS)
        expected_values = [
          '2 tab(s)', # Strength
          'APR 26, 2010', # Start Date
          '--', # End Date
          '2 tab(s)', # Quantity
          'code text', # Frequency
          '--', # Compliance
          '--', # Category
          'Testing additional information, thank you for reading this' # Additional Instructions
        ]
        check_entry expected_values, strength_tooltip_labels

        last_start_date = expected_values[1].to_datetime

        (2..find_all('.tooltip-entry').count).each do |n|
          within(".tooltip-entry:nth-of-type(#{n})") do
            check_tooltip find_all('.tooltip-label'), strength_tooltip_labels
            current_start_date = find_all('.tooltip-value')[1].text.to_datetime
            expect(last_start_date).to be >= current_start_date
            last_start_date = current_start_date
          end
        end
      end

      scenario 'nested entry displays tooltip' do
        find('.med-group:nth-of-type(6)').hover
        expected_values = [
          'APR 26, 2012', # Start Date
          'FEB 26, 2013', # End Date
          '6 tab(s)', # Quantity
          'code text', # Frequency
          '--', # Compliance
          '--', # Category
          'Testing additional information, thank you for reading this' # Additional Instructions
        ]
        check_entry expected_values

        bar_one = find('.med-group:nth-of-type(5) rect')
        bar_two = find('.med-group:nth-of-type(6) rect')
        bar_one_position = CheckGraph::Bars.get_position(bar_one[:transform])
        bar_two_position = CheckGraph::Bars.get_position(find('.med-group:nth-of-type(6) rect')[:transform])

        expect(bar_one_position[:y]).to eq(bar_two_position[:y])
        expect(bar_one_position[:x] + bar_one[:width].to_f).to be > (bar_two_position[:x] + bar_two[:width].to_f)
      end
    end
  end
end
