require 'rails_helper'

RSpec.feature 'Blood Pressure Results Collapse and Expand' do
  before(:each) do
    setup_session
    visit_root_page(:has_data)
    expect_page_no_errors
  end

  after(:each) do |example|
    CapybaraHelper.take_screenshot(page) unless example.exception
  end

  scenario 'displays results without any errors' do
    expect_blood_pressure_graph
  end

  context 'click blood pressure title once' do
    before(:each) do
      within('.blood-pressure-container') do
        find('.terra-Title').click
        sleep 0.5 # wait for animation to end
      end
    end

    scenario 'section is collapsed' do
      within('.blood-pressure-container') do
        expect(page).not_to have_selector('.graph-container')
        expect(page).not_to have_selector('.graph-sidebar')
      end
    end
  end

  context 'click blood pressure title twice' do
    before(:each) do
      within('.blood-pressure-container') do
        find('.terra-Title').click
        sleep 0.5 # wait for animation to end
        expect(page).not_to have_selector('.graph-container')
        expect(page).not_to have_selector('.graph-sidebar')
        find('.terra-Title').click
        sleep 0.5 # wait for animation to end
      end
    end

    scenario 'section is expanded' do
      within('.blood-pressure-container') do
        expect(page).to have_selector('.graph-container')
        expect(page).to have_selector('.graph-sidebar')
      end
    end
  end
end
