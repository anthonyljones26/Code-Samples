require 'rails_helper'

RSpec.feature 'Blood Pressure Results by Diastolic Range' do
  before(:each) do
    setup_session
    visit_root_page(:home_data)
    expect_page_no_errors
    @systolic_count = find('.d3-lines').all('.systolic-point').size
    @diastolic_count = find('.d3-lines').all('.diastolic-point').size
  end

  after(:each) do |example|
    CapybaraHelper.take_screenshot(page) unless example.exception
  end

  context 'disable diastolic data' do
    before(:each) do
      find_field('diastolic-checkbox').click
      expect(page).not_to have_checked_field('diastolic-checkbox')
    end

    scenario 'should hide diastolic BP' do
      expect(page).to have_selector('.blood-pressure-chart .d3-lines .systolic-point', between: 1..@systolic_count)
    end

    context 'disable all BP' do
      before(:each) do
        find_field('home-bp-checkbox').click
        find_field('office-bp-checkbox').click
        find_field('other-bp-checkbox').click
        expect(page).not_to have_checked_field('home-bp-checkbox')
        expect(page).not_to have_checked_field('office-bp-checkbox')
        expect(page).not_to have_checked_field('other-bp-checkbox')
      end

      scenario 'should hide all BP' do
        expect(page).not_to have_selector('.blood-pressure-chart .d3-lines .systolic-point')
        expect(page).not_to have_selector('.blood-pressure-chart .d3-lines .diastolic-point')
      end

      context 'enable only Home BP' do
        before(:each) do
          find_field('home-bp-checkbox').click
          expect(page).to have_checked_field('home-bp-checkbox')
        end

        scenario 'should show systolic Home BP' do
          expect(page).to have_selector('.blood-pressure-chart .d3-lines .systolic-point', between: 1..@systolic_count)
          expect(page).not_to have_selector('.blood-pressure-chart .d3-lines .diastolic-point')
        end
      end

      context 'enable only Office BP' do
        before(:each) do
          find_field('office-bp-checkbox').click
          expect(page).to have_checked_field('office-bp-checkbox')
        end

        scenario 'should show systolic Office BP' do
          expect(page).to have_selector('.blood-pressure-chart .d3-lines .systolic-point', between: 1..@systolic_count)
          expect(page).not_to have_selector('.blood-pressure-chart .d3-lines .diastolic-point')
        end
      end

      context 'enable only Other BP' do
        before(:each) do
          find_field('other-bp-checkbox').click
          expect(page).to have_checked_field('other-bp-checkbox')
        end

        scenario 'should show systolic other BP' do
          expect(page).to have_selector('.blood-pressure-chart .d3-lines .systolic-point', between: 1..@systolic_count)
          expect(page).not_to have_selector('.blood-pressure-chart .d3-lines .diastolic-point')
        end
      end

      context 'enable diastolic data' do
        before(:each) do
          find_field('diastolic-checkbox').click
          expect(page).to have_checked_field('diastolic-checkbox')
        end

        scenario 'should hide all BP' do
          expect(page).not_to have_selector('.blood-pressure-chart .d3-lines .systolic-point')
          expect(page).not_to have_selector('.blood-pressure-chart .d3-lines .diastolic-point')
        end

        context 'enable all BP' do
          before(:each) do
            find_field('home-bp-checkbox').click
            find_field('office-bp-checkbox').click
            find_field('other-bp-checkbox').click
            expect(page).to have_checked_field('home-bp-checkbox')
            expect(page).to have_checked_field('office-bp-checkbox')
            expect(page).to have_checked_field('other-bp-checkbox')
          end

          scenario 'should show all BP' do
            expect(find('.d3-lines').all('.systolic-point').size).to eq @systolic_count
            expect(find('.d3-lines').all('.diastolic-point').size).to eq @diastolic_count
          end
        end
      end
    end
  end
end
