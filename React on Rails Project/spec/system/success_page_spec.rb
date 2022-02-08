require 'rails_helper'
require 'portal/careaware_api'

SUCCESS_TYPES = {
  pickup: {
    option: 'pickup',
    banner: 'vial is ready for pick up.',
    address_header: 'Pick Up Location'
  },
  deliver: {
    option: 'deliver',
    banner: 'your vial has been mailed.',
    address_header: 'Delivery Location'
  }
}.freeze

RSpec.describe 'Refill with insurance', type: :system do
  after(:each) { |example| CapybaraHelper.take_screenshot(page) unless example.exception }

  shared_examples 'success page' do |type|
    it('should display correct patient name') { expect(page).to have_selector '.patient-container', text: 'PEACH TEST' }
    it('should render records label') { expect(page).to have_selector '.records-label', text: 'for your records.' }
    it("should display banner for #{type[:option]} message") do
      expect(page).to have_selector '.banner-container', text: type[:banner]
    end

    it("should display address header for #{type[:option]}") do
      expect(page).to have_selector '.address-container', text: type[:address_header]
    end

    it('should display address for allergy clinic') do
      assert_selector '.address-container', text: address.to_address_str.chomp
    end
  end

  context 'render success page' do
    context 'non mu insurance' do
      let(:address) { Address.new(streetAddress1: '812 Keene Street', city: 'Columbia', state: 'MO', zipcode: '65201') }
      before(:each) { visit_index }
      context 'pick up refill' do
        before do
          fill_out_form
          click_save
        end
        it_behaves_like 'success page', SUCCESS_TYPES[:pickup]
      end

      context 'refill will be delivered' do
        let(:address) do
          Address.new(
            streetAddress1: 'test st.',
            streetAddress2: 'building 2',
            city: 'columbia',
            state: 'MO',
            zipcode: '65201'
          )
        end
        before do
          select_insurance
          select_recent_visit
          select_delivery_method :deliver
          populate_delivery_field address
          click_save
        end
        it_behaves_like 'success page', SUCCESS_TYPES[:deliver]
      end

      context 'selected no recent visit' do
        before do
          select_insurance
          select_recent_visit false
          select_delivery_method
          click_save
        end
        it_behaves_like 'success page', SUCCESS_TYPES[:pickup]
        it 'should display recent visit warning banner' do
          assert_selector '.banner-container', text: 'The Allergy Clinic will still mix this vial,'
        end
      end
    end

    context 'Patient has MU insurance' do
      before do
        visit_index :single, :mu_insurance
        fill_out_form
        click_save
      end
      it 'should display copay message and banner' do
        assert_selector '.copay-warning', text: "Co-pay $71.25\nYou will be billed for the co-pay amount."
      end
    end
  end
end
