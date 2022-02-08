class KeepAliveController < ApplicationController
  before_action :authorize_user, only: [:index]
  def index
    return render_unauthorized unless @fhir_service.reauthorize

    message_json = { expireTime: session_token_expires_at }
    render_ok(message_json)
  end
end
