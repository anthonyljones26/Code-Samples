require 'rails_helper'

RSpec.feature 'Medication Graph Collapse and Expand' do
  before(:each) do
    setup_session
    visit_root_page(:has_data)
    expect_page_no_errors
  end

  after(:each) do |example|
    CapybaraHelper.take_screenshot(page) unless example.exception
  end

  scenario 'displays results without any errors' do
    expect_medication_graph
  end

  context 'click medication timeline title once' do
    before(:each) do
      within('.medication-container') do
        find('.terra-Title').click
        sleep 0.5 # wait for animation to end
      end
    end

    scenario 'section is collapsed' do
      within('.medication-container') do
        expect(page).not_to have_selector('.graph-container')
      end
    end
  end

  context 'click medication timeline title twice' do
    before(:each) do
      within('.medication-container') do
        find('.terra-Title').click
        sleep 0.5 # wait for animation to end
        expect(page).not_to have_selector('.graph-container')
        find('.terra-Title').click
        sleep 0.5 # wait for animation to end
      end
    end

    scenario 'section is expanded' do
      within('.medication-container') do
        expect(page).to have_selector('.graph-container')
      end
    end
  end
end
