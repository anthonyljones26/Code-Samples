require 'rails_helper'

RSpec.feature 'Medication Graph Timeline' do
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

  scenario 'displays ordered medications' do
    ticks = find_all('svg.medication-timeline-chart g.d3-y-axis g.tick title')

    expect(ticks[0].text).to eq('Medication A')
    expect(ticks[1].text).to eq('Medication B')
    expect(ticks[2].text).to eq('Medication C')
    expect(ticks[3].text).to eq('Medication D-RX')
  end

  context 'display on different screen sizes' do
    scenario 'graph exists small', device_size: :small do
      expect(page).to have_css 'svg.medication-timeline-chart'
    end

    scenario 'graph exists medium', device_size: :medium do
      expect(page).to have_css 'svg.medication-timeline-chart'
    end

    scenario 'graph exists large', device_size: :large do
      expect(page).to have_css 'svg.medication-timeline-chart'
    end

    scenario 'graph exists xlarge', device_size: :xlarge do
      expect(page).to have_css 'svg.medication-timeline-chart'
    end
  end

  context 'displays correct graph data' do
    context 'when multiple entries on a line' do
      scenario 'if first entry has no endDate end at today' do
        find('.med-group:nth-of-type(5)').hover
        expected_values = [
          '5 tab(s)', # Strength
          'APR 26, 2010', # Start Date
          '--', # End Date
          '5 tab(s)', # Quantity
          'code text', # Frequency
          'Taking', # Compliance
          'Office/Outpatient/ED', # Category
          '--' # Additional Instructions
        ]
        check_entry expected_values, (['Strength'] + TOOLTIP_LABELS)

        bar_one = find('.med-group:nth-of-type(5) rect')
        size = page.driver.evaluate_script <<-EO
          function() {
            var ele  = document.getElementsByClassName('medication-timeline')[0];
            var rect = ele.getBoundingClientRect();
            return [rect.width, rect.height];
          }();
        EO
        graph_width = size[0]
        bar_one_position = CheckGraph::Bars.get_position(bar_one[:transform])
        bar_two_position = CheckGraph::Bars.get_position(find('.med-group:nth-of-type(6) rect')[:transform])

        expect(bar_one_position[:y]).to eq(bar_two_position[:y])
        expect(bar_one_position[:x] + bar_one[:width].to_f).to eq(graph_width)
      end
    end
  end

  context 'on bar hover' do
    scenario 'bar is highlighted' do
      # hover over bar
      within('.med-group:nth-of-type(7)') do
        bar = find('.med-bar')
        label = find('.med-bar-label', visible: :hidden) # this is considered hidden because it has no text
        bar.hover
        expect(bar.native.css_value('fill-opacity')).to eq('0.9')
        expect(bar.native.css_value('stroke-width')).to eq('2px')
        expect(bar.native.css_value('stroke-opacity')).to eq('1')
        expect(label.native.css_value('fill-opacity')).to eq('1')
      end

      # bar in same row as hover over bar
      within('.med-group:nth-of-type(8)') do
        bar = find('.med-bar')
        label = find('.med-bar-label')
        expect(bar.native.css_value('fill-opacity')).to eq('0.05')
        expect(bar.native.css_value('stroke-width')).to eq('1px')
        expect(bar.native.css_value('stroke-opacity')).to eq('0.2')
        expect(label.native.css_value('fill-opacity')).to eq('0.05')
      end

      # bar in different row
      within('.med-group:nth-of-type(1)') do
        bar = find('.med-bar')
        label = find('.med-bar-label')
        expect(bar.native.css_value('fill-opacity')).to eq('0.7')
        expect(bar.native.css_value('stroke-width')).to eq('1px')
        expect(bar.native.css_value('stroke-opacity')).to eq('1')
        expect(label.native.css_value('fill-opacity')).to eq('1')
      end
    end
  end

  scenario 'disclaimer text visible' do
    expect(find('.disclaimer').text).to eq('* ' + I18n.t('medication.disclaimer'))
  end

  context 'case in-sensitive medication merge' do
    scenario 'one tick is made for two entries' do
      ticks = find_all('svg.medication-timeline-chart g.d3-y-axis g.tick title')
      expect(ticks[9].text).to eq('MEDICATION J')
      expect(ticks[10]).to be_nil
    end

    # should have 2 tooltip entries
    scenario '' do
      find('.med-group:nth-of-type(1)').hover
      expect(find_all('.tooltip-entry').size).to eq(2)
    end
  end
end
