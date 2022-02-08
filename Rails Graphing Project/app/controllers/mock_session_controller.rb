class MockSessionController < ApplicationController
  def index
    session_response
  end

  def set
    valid_session = load_json('spec/fixtures/sessions/valid_session.json')
    valid_session['token_response']['cerrner_srg'] = params[:cerrner_srg] if params[:cerrner_srg]
    valid_session.each do |key, value|
      session[key.to_sym] = value.with_indifferent_access
    end
    session_response
  end

  private

  def load_json(filename)
    JSON.parse(File.read(Rails.root.join(filename)))
  rescue StandardError
    {}
  end

  def session_response
    respond_to do |format|
      format.any { render json: session, status: :ok }
    end
  end
end
