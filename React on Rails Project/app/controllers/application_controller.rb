require 'portal/http_responses'

class ApplicationController < ActionController::Base
  include Portal::HttpResponses
  include Concerns::Authentication
  include Concerns::ErrorHandling
  include Concerns::Embeddable

  skip_before_action :require_login, only: [:render_unauthorized] # rubocop:disable Rails/LexicallyScopedActionFilter

  protect_from_forgery with: :exception

  helper_method :session_bcs_token

  private

  def session_bcs_token
    request.session[ActionDispatch::Session::TokenSessionStore::TOKEN]
  end
end
