require 'rails_helper'
RSpec.describe 'Patient Refill Different Error Messages', type: :system do
  before(:each) { visit_index :single }
  after(:each) { |example| CapybaraHelper.take_screenshot(page) unless example.exception }

  context 'pay with insurance' do
    before(:each) { fill_out_form }
    context 'nursing pool message failed to be sent' do
      it 'should display error banner for internal server error' do
        click_save message_status: :INTERNALSERVER
        expect(page).to have_selector '.banner-container', text: 'We are unable to complete your allergy vial refill ' \
        'request at this time. Please call the Allergy Clinic at 573-817-3000 to request your refill.'
      end

      it 'should display error banner for unprocessable entity error' do
        click_save message_status: :UNPROCESSABLE
        expect(page).to have_selector '.banner-container', text: 'We are unable to complete your allergy vial refill ' \
        'request at this time. Please call the Allergy Clinic at 573-817-3000 to request your refill.'
      end
    end
    ############################ DISABLE DUE TO CREATE VISIT LOGIC NOT USED UNTIL SELF PAY #############################
    # context 'HCO create_visit failed to create' do
    #   scenario 'should display error banner for internal server error' do
    #     click_save visit_status: :INTERNALSERVER
    #     expect(page).to have_selector '.banner-container', text: 'We are unable to complete your allergy vial refill
    #     ' \'request at this time. Please call the Allergy Clinic at 573-817-3000 to request your refill.'
    #   end

    #   scenario 'should display error banner for unprocessable entity error' do
    #     click_save visit_status: :UNPROCESSABLE
    #     expect(page).to have_selector '.banner-container', text: 'We are unable to complete your allergy vial refill
    #     ' \ 'request at this time. Please call the Allergy Clinic at 573-817-3000 to request your refill.'
    #   end
    # end
    ####################################################################################################################
  end
end
