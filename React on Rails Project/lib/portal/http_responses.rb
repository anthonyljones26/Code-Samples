module Portal
  module HttpResponses
    HAS_ERROR_TEMPLATE = [
      :unauthorized, :forbidden, :not_found, :unprocessable_entity, :internal_server_error
    ].freeze

    # NOTE: not all of the following methods are used by this app, keeping for easier maintenance between projects

    def render_ok(message = {})
      render_success_response(:ok, message)
    end

    def render_created(message = {})
      render_success_response(:created, message)
    end

    def render_no_content
      render_success_response(:no_content)
    end

    def render_no_relationship
      error_status = :no_relationship
      response_status = :ok

      response.headers['Completed-At'] = Time.now.strftime('%Y-%m-%d %H:%M:%S.%3N')
      setup_error_props(error_status)

      respond_to do |format|
        format.json { render json: { error: 'No Relationship' }, status: response_status }
        format.html { render template: 'errors/error', status: response_status }
        format.any { render plain: 'No Relationship', status: response_status }
      end
    end

    def render_unauthorized
      render_generic_error_response :unauthorized
    end

    def render_forbidden
      render_generic_error_response :forbidden
    end

    def render_not_found
      render_generic_error_response :not_found
    end

    def render_unprocessable_entity
      render_generic_error_response :unprocessable_entity
    end

    def render_internal_server_error(message = {})
      if message.blank?
        render_generic_error_response :internal_server_error
      else
        render_http_response(:internal_server_error, { error: message }, message.to_s)
      end
    end

    private

    def setup_error_props(status)
      @error_props = {
        locale: I18n.locale,
        status: status,
        errorPageLinks: {
          supportPhone: APP_CONFIG['support_phone'],
          selfEnrollURL: APP_CONFIG['self_enroll_url']
        },
        dexConfig: {
          acls: APP_CONFIG['dex_issuer_jwk_xref'].keys,
          loginUrl: APP_CONFIG['login_url'],
          detectIframe: APP_CONFIG['detect_iframe'],
          refreshToken: {
            url: refresh_token_url
          },
          bcsToken: '0'
        }
      }
    end

    def render_http_response(status, message_json, message_plain)
      response.headers['Completed-At'] = Time.now.strftime('%Y-%m-%d %H:%M:%S.%3N')
      setup_error_props(status)

      respond_to do |format|
        format.json { render json: message_json, status: status }
        format.html { render template: 'errors/error', status: status } if HAS_ERROR_TEMPLATE.include?(status)
        format.any { render plain: message_plain, status: status }
      end
    end

    def render_generic_error_response(status)
      message = Rack::Utils::HTTP_STATUS_CODES[Rack::Utils.status_code(status)]
      render_http_response(status, { error: message }, message)
    end

    def render_success_response(status, message = {})
      render_http_response(status, message, message.to_s)
    end
  end
end
