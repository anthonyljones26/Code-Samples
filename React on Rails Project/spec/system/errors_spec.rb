require 'rails_helper'

RSpec.describe 'allergy/errors' do
  before(:each) do
    visit_index :single
  end

  after(:each) do
    CapybaraHelper.take_screenshot(page) unless failed?
  end

  it 'render 401 error page' do
    visit unauthorized_url
    expect(page).to have_content('Unauthorized Access')
  end

  it 'render 403 error page' do
    visit forbidden_url
    expect(page).to have_content('Unauthorized Access')
  end

  it 'render 404 error page' do
    visit not_found_url(bcs_token: 'abc')
    expect(page).to have_content('Page Not Found')
  end

  it 'render 500 error page' do
    visit internal_server_error_url(bcs_token: 'abc')
    expect(page).to have_content('An Error Has Occurred')
  end

  it 'render 500 on unhandled internal server error' do
    allow_any_instance_of(RefillController).to receive(:index).and_raise(StandardError)
    visit root_url(bcs_token: 'abc')
    expect(page).to have_content('An Error Has Occurred')
  end

  it 'render no relationship error page' do
    visit no_relationship_url(bcs_token: 'abc')
    expect(page).to have_content('You need an invitation to access HEALTHConnect')
  end
end
