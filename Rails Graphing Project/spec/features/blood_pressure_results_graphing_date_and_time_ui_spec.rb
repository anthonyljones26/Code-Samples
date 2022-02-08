require 'rails_helper'

RSpec.feature 'Blood Pressure Results Graphing Date and Time UI' do
  before(:each) do
    setup_session
  end

  after(:each) do |example|
    CapybaraHelper.take_screenshot(page) unless example.exception
  end

  context 'date range extending multiple years' do
    before(:each) do
      visit_root_page(:extend_year)
      expect_page_no_errors
    end

    context 'default of 2 Months' do
      scenario 'show graph with 2 months date range' do
        expect(page).to have_select('date-range', selected: '2 Months')
        expect(page).to have_selector('svg#chart g.d3-axis g.d3-x-axis g.tick', maximum: 9, minimum: 8)
        ticks = find_all('svg#chart g.d3-axis g.d3-x-axis g.tick')
        CheckGraph::Ticks.day_through_year(ticks)
      end
    end

    context 'select 1 Week' do
      before(:each) do
        select_one_week(:extend_year)
      end

      scenario 'update graph with 1 week date range' do
        expect(page).to have_select('date-range', selected: '1 Week')
        expect(page).to have_selector('svg#chart g.d3-axis g.d3-x-axis g.tick', maximum: 8, minimum: 7)
        ticks = find_all('svg#chart g.d3-axis g.d3-x-axis g.tick')
        CheckGraph::Ticks.day_through_year(ticks)
      end
    end

    context 'select 1 Month' do
      before(:each) do
        select_one_month(:extend_year)
      end

      scenario 'update graph with 1 month date range' do
        expect(page).to have_select('date-range', selected: '1 Month')
        expect(page).to have_selector('svg#chart g.d3-axis g.d3-x-axis g.tick', maximum: 9, minimum: 8)
        ticks = find_all('svg#chart g.d3-axis g.d3-x-axis g.tick')
        CheckGraph::Ticks.day_through_year(ticks)
      end
    end

    context 'select 2 Months' do
      before(:each) do
        select_one_week(:extend_year) # 2 months is the default, select something else first to force an action
        select_two_months(:extend_year)
      end

      scenario 'update graph with 2 months date range' do
        expect(page).to have_select('date-range', selected: '2 Months')
        expect(page).to have_selector('svg#chart g.d3-axis g.d3-x-axis g.tick', maximum: 9, minimum: 8)
        ticks = find_all('svg#chart g.d3-axis g.d3-x-axis g.tick')
        CheckGraph::Ticks.day_through_year(ticks)
      end
    end
  end

  context 'normal date range' do
    before(:each) do
      setup_session
      visit_root_page(:has_data)
      expect_page_no_errors
    end

    context 'default of 2 Months' do
      scenario 'show graph with 2 months date range' do
        expect(page).to have_select('date-range', selected: '2 Months')
        expect(page).to have_selector('svg#chart g.d3-axis g.d3-x-axis g.tick', maximum: 9, minimum: 8)
        ticks = find_all('svg#chart g.d3-axis g.d3-x-axis g.tick')
        CheckGraph::Ticks.day(ticks)
      end
    end

    context 'select 1 Day' do
      before(:each) do
        select_one_day(:has_data)
      end

      scenario 'update graph with 1 day date range' do
        expect(page).to have_select('date-range', selected: '1 Day')
        expect(page).to have_selector('svg#chart g.d3-axis g.d3-x-axis g.tick', maximum: 9, minimum: 8)
        ticks = find_all('svg#chart g.d3-axis g.d3-x-axis g.tick')
        CheckGraph::Ticks.hour(ticks)
      end
    end

    context 'select 1 Week' do
      before(:each) do
        select_one_week(:has_data)
      end

      scenario 'update graph with 1 week date range' do
        expect(page).to have_select('date-range', selected: '1 Week')
        expect(page).to have_selector('svg#chart g.d3-axis g.d3-x-axis g.tick', maximum: 8, minimum: 7)
        ticks = find_all('svg#chart g.d3-axis g.d3-x-axis g.tick')
        CheckGraph::Ticks.day(ticks)
      end
    end

    context 'select 1 Month' do
      before(:each) do
        select_one_month(:has_data)
      end

      scenario 'update graph with 1 month date range' do
        expect(page).to have_select('date-range', selected: '1 Month')
        expect(page).to have_selector('svg#chart g.d3-axis g.d3-x-axis g.tick', maximum: 9, minimum: 8)
        ticks = find_all('svg#chart g.d3-axis g.d3-x-axis g.tick')
        CheckGraph::Ticks.day(ticks)
      end
    end

    context 'select 2 Months' do
      before(:each) do
        select_one_day(:has_data) # 2 months is the default, select something else first to force an action
        select_two_months(:has_data)
      end

      scenario 'update graph with 2 months date range' do
        expect(page).to have_select('date-range', selected: '2 Months')
        expect(page).to have_selector('svg#chart g.d3-axis g.d3-x-axis g.tick', maximum: 9, minimum: 8)
        ticks = find_all('svg#chart g.d3-axis g.d3-x-axis g.tick')
        CheckGraph::Ticks.day(ticks)
      end
    end

    context 'select 6 Months' do
      before(:each) do
        select_six_months(:has_data)
      end

      scenario 'update graph with 6 months date range' do
        expect(page).to have_select('date-range', selected: '6 Months')
        expect(page).to have_selector('svg#chart g.d3-axis g.d3-x-axis g.tick', maximum: 7, minimum: 6)
        ticks = find_all('svg#chart g.d3-axis g.d3-x-axis g.tick')
        CheckGraph::Ticks.month(ticks)
      end
    end

    context 'select 1 Year' do
      before(:each) do
        select_one_year(:has_data)
      end

      scenario 'update graph with 1 year date range' do
        expect(page).to have_select('date-range', selected: '1 Year')
        expect(page).to have_selector('svg#chart g.d3-axis g.d3-x-axis g.tick', maximum: 13, minimum: 12)
        ticks = find_all('svg#chart g.d3-axis g.d3-x-axis g.tick')
        CheckGraph::Ticks.month(ticks)
      end
    end

    context 'select 2 Years' do
      before(:each) do
        select_two_years(:has_data)
      end

      scenario 'update graph with 2 years date range' do
        expect(page).to have_select('date-range', selected: '2 Years')
        expect(page).to have_selector('svg#chart g.d3-axis g.d3-x-axis g.tick', maximum: 13, minimum: 12)
        ticks = find_all('svg#chart g.d3-axis g.d3-x-axis g.tick')
        CheckGraph::Ticks.month(ticks)
      end
    end
  end
end
