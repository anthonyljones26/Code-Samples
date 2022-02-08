require 'results_graphing_fhir/logger'
require 'date'

class ApplicationController < ActionController::Base
  include ResultsGraphingFhir::Logger
  include Concerns::LaunchConfigParser
  protect_from_forgery with: :exception
  rescue_from Redis::CannotConnectError, with: :redis_error_handler

  private

  def redis_error_handler
    # TODO: setup error handler
    render file: 'public/500.html', status: :internal_server_error, layout: false
    true
  end

  def render_ok(message_json)
    respond_to do |format|
      response.headers['Completed-At'] = DateTime.now.strftime('%Y-%m-%d %H:%M:%S.%3N')
      format.json { render json: message_json, status: :ok }
    end
  end

  def render_internal_server_error(message_json)
    respond_to do |format|
      response.headers['Completed-At'] = DateTime.now.strftime('%Y-%m-%d %H:%M:%S.%3N')
      format.json { render json: message_json, status: :internal_server_error }
    end
  end

  def render_unauthorized
    respond_to do |format|
      response.headers['Completed-At'] = DateTime.now.strftime('%Y-%m-%d %H:%M:%S.%3N')
      format.json { render json: '', status: :unauthorized }
    end
  end

  def authorize_user
    @codes = FHIR_CLIENTS_CONFIG['clients'][session[:server][:url]]['codes']
    token_uri = session[:server][:oauth2][:token_uri]
    fhir_service_url = session[:server][:url]
    lambda_token_updater = ->(token_response) { session[:token_response].merge!(token_response) }
    @fhir_service = FhirServices::Client.new(
      session[:token_response], token_uri, fhir_service_url, lambda_token_updater
    )
  rescue StandardError
    render_unauthorized
  end

  def setup_date_range
    date_range = date_range_params
    {
      greater_equal: date_range['start']&.to_datetime,
      less_equal: date_range['end']&.to_datetime
    }.compact
  end

  def date_range_params
    params.permit(:start, :end)
  end

  def session_token_expires_at
    return DateTime.now if session[:token_response].nil?

    time = DateTime.parse((session[:token_response]['created_at']).to_s)
    expires_in = session[:token_response]['expires_in'].to_i
    time + expires_in.seconds
  end
  helper_method :session_token_expires_at
end
