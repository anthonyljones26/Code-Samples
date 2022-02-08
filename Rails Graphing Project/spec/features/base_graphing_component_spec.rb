require 'rails_helper'

RSpec.feature 'Base Graphing Component' do
  after(:each) do |example|
    CapybaraHelper.take_screenshot(page) unless example.exception
  end

  context 'smart launch fail' do
    before(:each) do
      # NOTE: visting page twice to help avoid random test failures
      visit root_path
      visit root_path(uuid: SecureRandom.uuid)
    end

    scenario 'shows error message - blood pressure graph' do
      within('.blood-pressure-container') do
        expect(page).not_to have_selector('.chart-container')
        expect(page).to have_selector('.error-container span', text: 'An Error Has Occurred')
      end
    end

    scenario 'shows error message - medication timeline' do
      within('.medication-container') do
        expect(page).not_to have_selector('.chart-container')
        expect(page).to have_selector('.error-container span', text: 'An Error Has Occurred')
      end
    end
  end

  context 'smart launch success' do
    before(:each) do
      setup_session
    end

    context 'no data' do
      before(:each) do
        visit_root_page(:no_data, mock_data: 'mock_no_data')
      end

      scenario 'shows no data message - blood pressure graph' do
        within('.blood-pressure-container') do
          expect(page).not_to have_selector('.chart-container')
          expect(page).to have_selector('.error-container span', text: 'No Data')
        end
      end

      scenario 'shows no data message - medication timeline' do
        within('.medication-container') do
          expect(page).not_to have_selector('.chart-container')
          expect(page).to have_selector('.error-container span', text: 'No Data')
        end
      end
    end

    context 'has data' do
      before(:each) do
        visit_root_page(:has_data)
      end

      scenario 'shows graph - blood pressure graph' do
        expect_blood_pressure_graph
      end

      scenario 'shows graph - medication timeline' do
        expect_medication_graph
      end
    end

    context 'modified data' do
      before(:each) do
        visit_root_page(:modified_data, mock_data: :mock_high_bp_data)
      end

      scenario 'shows blood pressure value over 200' do
        within('.blood-pressure-container') do
          expect(find('g.d3-y-axis g.tick:last-of-type').text).to eq '220'
        end
      end
    end
  end

  context 'date range' do
    scenario 'shows date range selector' do
      setup_session
      visit_root_page(:has_data)
      expect_date_range_options
    end

    scenario 'shows date range selector with 2 Years selected' do
      setup_session('-t2Y MED.M OBS.BP.m.s')
      visit_root_page(:has_data)
      expect_date_range_options('2 Years')
    end
  end

  context 'expand/collapse configs' do
    scenario 'blood pressure graph collapsed by default' do
      setup_session('MED.M OBS.BP.m', is_expanded_bp: false)
      visit_root_page(:has_data, is_expanded_bp: false)
      expect(page).not_to have_selector('.blood-pressure-container .toggle-body')
    end

    scenario 'medication timeline collapsed by default' do
      setup_session('MED.m OBS.BP.M', is_expanded_med: false)
      visit_root_page(:has_data, is_expanded_med: false)
      expect(page).not_to have_selector('.medication-container .toggle-body')
    end
  end

  context 'component combinations' do
    scenario 'one medication timeline and one blood pressure graph' do
      setup_session('MED OBS.BP')
      visit_root_page(:has_data)
      expect(page).to have_selector('.medication-container', count: 1)
      expect(page).to have_selector('.blood-pressure-container', count: 1)
      expect(find('.main > div:nth-child(2)')[:class]).to eq('graph-main medication-container')
    end

    scenario 'two medication timelines and two blood pressure graphs' do
      setup_session('MED MED OBS.BP OBS.BP')
      visit_root_page(:has_data)
      expect(page).to have_selector('.medication-container', count: 2)
      expect(page).to have_selector('.blood-pressure-container', count: 2)
      expect(find('.main > div:nth-child(2)')[:class]).to eq('graph-main medication-container')
      expect(find('.main > div:nth-child(4)')[:class]).to eq('graph-main blood-pressure-container')
    end

    scenario 'one medication timeline' do
      setup_session('MED')
      visit_root_page(:has_data)
      expect(page).to have_selector('.medication-container', count: 1)
      expect(page).not_to have_selector('.blood-pressure-container')
    end

    scenario 'two medication timelines' do
      setup_session('MED MED')
      visit_root_page(:has_data)
      expect(page).to have_selector('.medication-container', count: 2)
      expect(page).not_to have_selector('.blood-pressure-container')
    end

    scenario 'two blood pressure graphs' do
      setup_session('OBS.BP OBS.BP')
      visit_root_page(:has_data)
      expect(page).to have_selector('.blood-pressure-container', count: 2)
      expect(page).not_to have_selector('.medication-container')
    end
  end
end
