class AuthController < ApplicationController
  skip_before_action :require_login, only: [:refresh_token]
  after_action :set_embeddable_headers, except: [:refresh_token]

  def refresh_token
    if verify_session_cloud_principal
      render_ok
    else
      render_unauthorized
    end
  end
end
