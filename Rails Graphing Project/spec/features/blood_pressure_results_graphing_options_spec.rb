require 'rails_helper'

RSpec.feature 'Blood Pressure Results Graphing Options' do
  before(:each) do
    setup_session
    visit_root_page(:has_data)
    expect_page_no_errors
  end

  after(:each) do |example|
    CapybaraHelper.take_screenshot(page) unless example.exception
  end

  context 'click the graph type selector' do
    scenario 'shows graph options' do
      expect_graph_options
    end
  end
end
