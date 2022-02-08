require 'rails_helper'

RSpec.describe AuthController, type: :controller do
  context 'refresh token is valid' do
    before :each do
      session['principal'] = 'user_12345'
      session['tide.bcs.principal'] = session['principal']
    end

    it 'handles refresh token from dex framework with success' do
      post :refresh_token, xhr: true
      expect(response).to have_http_status '200'
    end
  end

  context 'refresh token is invalid' do
    before :each do
      session['principal'] = 'user_12345'
      session['tide.bcs.principal'] = 'ABCD'
    end

    it 'returns an error from dex framework' do
      post :refresh_token, xhr: true
      expect(response).to have_http_status '401'
    end
  end

  context 'refresh token when session is empty' do
    before :each do
      session.clear
    end

    it 'returns an error from dex framework' do
      post :refresh_token, xhr: true
      expect(response).to have_http_status '401'
    end
  end
end
