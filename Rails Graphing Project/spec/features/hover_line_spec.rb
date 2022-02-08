require 'rails_helper'

RSpec.feature 'Hover Line' do
  before(:each) do
    setup_session
    visit_root_page(:has_data)
    select_two_years(:has_data)
    expect_page_no_errors
  end

  after(:each) do |example|
    CapybaraHelper.take_screenshot(page) unless example.exception
  end

  context 'hover over blood pressure graph' do
    before(:each) do
      find('.blood-pressure-container').hover
    end

    scenario 'shows hover lines on BP and medication graphs' do
      bp_line_selector = '.blood-pressure-container .graph-container .chart-container .mouse-line'
      mt_line_selector = '.medication-container .medication-timeline-chart .mouse-line'
      expect(page).to have_selector(bp_line_selector)
      expect(page).to have_selector(mt_line_selector)
      expect(page.find(bp_line_selector).native.css_value('opacity')).to eq('1')
      expect(page.find(mt_line_selector).native.css_value('opacity')).to eq('1')
    end

    context 'hover away from graphs' do
      before(:each) do
        find('#date-range').hover
      end

      scenario 'hides hover lines' do
        bp_line_selector = '.blood-pressure-container .graph-container .chart-container .mouse-line'
        mt_line_selector = '.medication-container .medication-timeline-chart .mouse-line'
        expect(page).not_to have_selector(bp_line_selector)
        expect(page).not_to have_selector(mt_line_selector)
      end
    end
  end

  context 'hover over medication graph' do
    before(:each) do
      find('.medication-container').hover
    end

    scenario 'shows hover lines on BP and medication graphs' do
      bp_line_selector = '.blood-pressure-container .graph-container .chart-container .mouse-line'
      mt_line_selector = '.medication-container .medication-timeline-chart .mouse-line'
      expect(page).to have_selector(bp_line_selector)
      expect(page).to have_selector(mt_line_selector)
      expect(page.find(bp_line_selector).native.css_value('opacity')).to eq('1')
      expect(page.find(mt_line_selector).native.css_value('opacity')).to eq('1')
    end

    context 'hover away from graphs' do
      before(:each) do
        find('#date-range').hover
      end

      scenario 'hides hover lines' do
        bp_line_selector = '.blood-pressure-container .graph-container .chart-container .mouse-line'
        mt_line_selector = '.medication-container .medication-timeline-chart .mouse-line'
        expect(page).not_to have_selector(bp_line_selector)
        expect(page).not_to have_selector(mt_line_selector)
      end
    end
  end
end
