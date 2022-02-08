require 'rails_helper'

RSpec.feature 'Blood Pressure Results by Systolic Range' do
  before(:each) do
    setup_session
    visit_root_page(:home_data)
    expect_page_no_errors
    @diastolic_count = find('.d3-lines').all('.diastolic-point').size
    @systolic_count = find('.d3-lines').all('.systolic-point').size
  end

  after(:each) do |example|
    CapybaraHelper.take_screenshot(page) unless example.exception
  end

  context 'disable systolic data' do
    before(:each) do
      find_field('systolic-checkbox').click
      expect(page).not_to have_checked_field('systolic-checkbox')
    end

    scenario 'should hide systolic BP' do
      expect(find('.d3-lines').all('.diastolic-point').size).to eq @diastolic_count
      expect(page).not_to have_selector('.blood-pressure-chart .d3-lines .systolic-point')
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
        expect(page).not_to have_selector('.blood-pressure-chart .d3-lines .diastolic-point')
        expect(page).not_to have_selector('.blood-pressure-chart .d3-lines .systolic-point')
      end

      context 'enable only Home BP' do
        before(:each) do
          find_field('home-bp-checkbox').click
          expect(page).to have_checked_field('home-bp-checkbox')
        end

        scenario 'should show diastolic Home BP' do
          expect(page).to have_selector(
            '.blood-pressure-chart .d3-lines .diastolic-point', between: 1..@diastolic_count
          )
          expect(page).not_to have_selector('.blood-pressure-chart .d3-lines .systolic-point')
        end
      end

      context 'enable only Office BP' do
        before(:each) do
          find_field('office-bp-checkbox').click
          expect(page).to have_checked_field('office-bp-checkbox')
        end

        scenario 'should show diastolic Office BP' do
          expect(page).to have_selector(
            '.blood-pressure-chart .d3-lines .diastolic-point', between: 1..@diastolic_count
          )
          expect(page).not_to have_selector('.blood-pressure-chart .d3-lines .systolic-point')
        end
      end

      context 'enable only Other BP' do
        before(:each) do
          find_field('other-bp-checkbox').click
          expect(page).to have_checked_field('other-bp-checkbox')
        end

        scenario 'should show diastolic Other BP' do
          expect(page).to have_selector(
            '.blood-pressure-chart .d3-lines .diastolic-point', between: 1..@diastolic_count
          )
          expect(page).not_to have_selector('.blood-pressure-chart .d3-lines .systolic-point')
        end
      end

      context 'enable systolic data' do
        before(:each) do
          find_field('systolic-checkbox').click
          expect(page).to have_checked_field('systolic-checkbox')
        end

        scenario 'should hide all BP' do
          expect(page).not_to have_selector('.blood-pressure-chart .d3-lines .diastolic-point')
          expect(page).not_to have_selector('.blood-pressure-chart .d3-lines .systolic-point')
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
            expect(find('.d3-lines').all('.diastolic-point').size).to eq @diastolic_count
            expect(find('.d3-lines').all('.systolic-point').size).to eq @systolic_count
          end
        end
      end
    end
  end
end
