require 'rails_helper'

RSpec.feature 'Medication Graph Bar Label' do
  before(:each) do
    setup_session
    visit_root_page(:has_data)
    select_two_years(:has_data)
    expect_page_no_errors
  end

  after(:each) do |example|
    CapybaraHelper.take_screenshot(page) unless example.exception
  end

  context 'displaying medication bars of various widths' do
    scenario 'does not display strength label in short medication bar' do
      within('.med-group:nth-of-type(2)') do
        expect(page).to_not have_selector('text')
      end
    end

    scenario 'displays strength label in medication bars' do
      within('.med-group:nth-of-type(3)') do
        expect(page).to have_selector('text')
        expect(page).to have_text('3 tab(s)')
      end
    end
  end
end
