module Concerns
  module Embeddable
    extend ActiveSupport::Concern

    included do
      after_action :set_embeddable_headers
    end

    private

    def url_to_base_uri(url)
      URI.join(url, '/').to_s.chomp('/')
    end

    def session_issuer_uri
      session[ActionDispatch::Session::TokenSessionStore::ISSUER]
    end

    def session_referer_uri
      return session[:referer_uri] if session[:referer_uri]

      if APP_CONFIG['dex_issuer_jwk_xref'].present? && request.referer
        referer_uri = url_to_base_uri(request.referer)
        session[:referer_uri] = referer_uri if APP_CONFIG['dex_issuer_jwk_xref'].include?(referer_uri)
      end

      session[:referer_uri]
    end

    def allow_uri
      session_issuer_uri || session_referer_uri || url_to_base_uri(request.url)
    end

    def set_embeddable_headers
      allow_uri = allow_uri()

      response.headers['p3p'] = 'CP="NON CUR OTPi OUR NOR UNI"'
      response.headers['X-Frame-Options'] = "allow-from #{allow_uri}/"
      response.headers['Content-Security-Policy'] = "frame-ancestors #{allow_uri}/;"
    end
  end
end
