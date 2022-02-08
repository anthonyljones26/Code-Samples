require 'rails_helper'

RSpec.feature 'Blood Pressure Results Source Types' do
  before(:each) do
    setup_session
    visit_root_page(:has_data)
    select_two_years(:has_data)
    expect_page_no_errors
  end

  after(:each) do |example|
    CapybaraHelper.take_screenshot(page) unless example.exception
  end

  scenario 'view source type options' do
    expect(page).to have_checked_field('home-bp-checkbox')
    expect(find('.home-bp-checkbox').find(:xpath, '..').text).to eq('Home')
    expect(page).to have_checked_field('office-bp-checkbox')
    expect(find('.office-bp-checkbox').find(:xpath, '..').text).to eq('Office')
    expect(page).to have_selector('.other-bp-checkbox')
  end

  context 'disable all source types' do
    before(:each) do
      find_field('home-bp-checkbox').click
      find_field('office-bp-checkbox').click
      find_field('other-bp-checkbox').click
    end

    scenario 'shows no graph data' do
      expect(page).not_to have_selector('.blood-pressure-chart .d3-lines .systolic-line')
      expect(page).not_to have_selector('.blood-pressure-chart .d3-lines .systolic-point')
      expect(page).not_to have_selector('.blood-pressure-chart .d3-lines .diastolic-line')
      expect(page).not_to have_selector('.blood-pressure-chart .d3-lines .diastolic-point')
      expect(page).not_to have_selector('.blood-pressure-chart .d3-lines .systolic-trend-line')
      expect(page).not_to have_selector('.blood-pressure-chart .d3-lines .diastolic-trend-line')
    end

    context 'enable only Home' do
      before(:each) do
        find_field('home-bp-checkbox').click
      end

      scenario 'shows only Home data' do
        expect(page).to have_selector('.blood-pressure-chart .d3-lines .systolic-line')
        expect(page).to have_selector('.blood-pressure-chart .d3-lines .diastolic-line')
        expect(page).to have_selector('.blood-pressure-chart .d3-lines .systolic-point', count: 14)
        expect(page).to have_selector('.blood-pressure-chart .d3-lines .diastolic-point', count: 14)
        expect(page).to have_selector('.blood-pressure-chart .d3-lines .systolic-trend-line')
        expect(page).to have_selector('.blood-pressure-chart .d3-lines .diastolic-trend-line')
      end
    end

    context 'enable only Office' do
      before(:each) do
        find_field('office-bp-checkbox').click
      end

      scenario 'shows only Office data' do
        expect(page).to have_selector('.blood-pressure-chart .d3-lines .systolic-line')
        expect(page).to have_selector('.blood-pressure-chart .d3-lines .diastolic-line')
        expect(page).to have_selector('.blood-pressure-chart .d3-lines .systolic-point', count: 6)
        expect(page).to have_selector('.blood-pressure-chart .d3-lines .diastolic-point', count: 6)
        expect(page).to have_selector('.blood-pressure-chart .d3-lines .systolic-trend-line')
        expect(page).to have_selector('.blood-pressure-chart .d3-lines .diastolic-trend-line')
      end
    end

    context 'enable only other' do
      before(:each) do
        find_field('other-bp-checkbox').click
      end

      scenario 'shows only other data' do
        expect(page).to have_selector('.blood-pressure-chart .d3-lines .systolic-line')
        expect(page).to have_selector('.blood-pressure-chart .d3-lines .diastolic-line')
        expect(page).to have_selector('.blood-pressure-chart .d3-lines .systolic-point', count: 3)
        expect(page).to have_selector('.blood-pressure-chart .d3-lines .diastolic-point', count: 3)
        expect(page).to have_selector('.blood-pressure-chart .d3-lines .systolic-trend-line')
        expect(page).to have_selector('.blood-pressure-chart .d3-lines .diastolic-trend-line')
      end
    end

    context 'enable all source types' do
      before(:each) do
        find_field('home-bp-checkbox').click
        find_field('office-bp-checkbox').click
        find_field('other-bp-checkbox').click
      end

      scenario 'shows all graph data' do
        expect(page).to have_selector('.blood-pressure-chart .d3-lines .systolic-line')
        expect(page).to have_selector('.blood-pressure-chart .d3-lines .systolic-point', count: 23)
        expect(page).to have_selector('.blood-pressure-chart .d3-lines .diastolic-line')
        expect(page).to have_selector('.blood-pressure-chart .d3-lines .diastolic-point', count: 23)
        expect(page).to have_selector('.blood-pressure-chart .d3-lines .systolic-trend-line')
        expect(page).to have_selector('.blood-pressure-chart .d3-lines .diastolic-trend-line')
      end
    end
  end
end
