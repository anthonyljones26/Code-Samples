require 'rails_helper'
require 'portal/careaware_api'

RSpec.describe 'Validate Refill Form', type: :system do
  after(:each) { |example| CapybaraHelper.take_screenshot(page) unless example.exception }

  context 'No health plans found' do
    before(:each) { visit_index :single, :no_insurance }
    it('should display information banner') { assert_selector('.no-insurance-warning') }
  end

  context 'failure to retrieve health plans' do
    before(:each) { visit_index :single, :error }
    it('should display error message') { assert_selector('.insurance-error') }
  end

  context 'select pay with insurance' do
    before(:each) { visit_index }
    it('should display insurance component') { assert_selector('.insurance-plan') }
    context 'select NO insurance is not current' do
      before(:each) { select_insurance 'INVALID' }
      it('should display information banner') { assert_selector('.insurance-plan-warning') }
    end

    context 'select YES insurance is current' do
      before(:each) { select_insurance }
      it('should display recent visit dropdown') { assert_selector('#recent-visit-select-field') }

      context 'select NO recent visits' do
        before(:each) { select_recent_visit false }
        it('should display information banner') { assert_selector('.recent-visit-warning') }
      end

      context 'select YES recent visits' do
        before(:each) { select_recent_visit }
        it('should not display information banner') { assert_no_selector('.recent-visit-warning') }
        context 'select \'Pick up\'' do
          before(:each) { select_delivery_method }
          it 'should display clinic address' do
            assert_selector('#pickup-clinic-address')
            assert_selector('button')
          end
        end

        context 'select \'Mail\'' do
          before(:each) { select_delivery_method :deliver }
          it 'should display address form' do
            assert_selector('.payment-style')
            assert_no_selector('button')
          end

          it 'should display Send button when address is valid' do
            assert_selector('.payment-style')
            address = Address.new streetAddress1: 'test street', city: 'columbia', state: 'missouri', zipcode: '65201'
            populate_delivery_field address
            assert_selector('button')
          end
        end
      end
    end
  end

  context 'Patient has MU insurance' do
    before do
      visit_index :single, :mu_insurance
      fill_out_form
    end

    it('it should display copay message and banner') do
      assert_selector '.copay-warning', text: "Co-pay $71.25\nYou will be billed for the co-pay amount."
    end
  end
end
