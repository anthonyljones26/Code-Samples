require 'rails_helper'

RSpec.describe 'Test PatientSwitcher', type: :system do
  after(:each) { |example| CapybaraHelper.take_screenshot(page) unless example.exception }

  context 'changing patient profile' do
    context 'mulitple users' do
      before(:each) { visit_index :multiple }

      it 'should show active user' do
        within('div[class*=toggle-patient-switcher') do
          expect_selector_containing('tide-patient-switcher-active', 'CAT ZTEST')
          expect_selector_containing('multi')
        end
      end

      context 'selecting different user' do
        it('shoud display new user in selector') { switch_patients('FOUR MOCK', 4, :no_insurance) }
        it 'shoud display no relationship page for subaccount with no MRN' do
          switch_patients('BRYAN ZTEST', 1) { expect(page).to have_current_path('/no-relationship?bcs_token=abc') }
        end
      end
    end

    context 'single user' do
      before(:each) { visit_index :single }
      it 'should show active user 1 and no dropdown' do
        within('div[class*=toggle-patient-switcher') do
          expect_selector_containing('tide-patient-switcher-active', 'PEACH TEST')
          expect_no_selector_containing('multi')
        end
      end
    end
  end
end
