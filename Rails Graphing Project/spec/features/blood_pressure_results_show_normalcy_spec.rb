require 'rails_helper'

RSpec.feature 'Blood Pressure Results Show Normalcy' do
  before(:each) do
    setup_session
    visit_root_page(:has_data)
    expect_page_no_errors
  end

  after(:each) do |example|
    CapybaraHelper.take_screenshot(page) unless example.exception
  end

  context 'disable normalcy' do
    before(:each) { find_field('normalcy-checkbox').click }

    scenario 'does not show normalcy bar' do
      expect(page).not_to have_css '.systolic-normalcy'
      expect(page).not_to have_css '.diastolic-normalcy'
    end

    context 'enable normalcy' do
      before(:each) do
        find_field('normalcy-checkbox').click
      end

      scenario 'shows normalcy bar' do
        expect(page).to have_css '.systolic-normalcy'
        expect(page).to have_css '.diastolic-normalcy'
      end
    end
  end
end
