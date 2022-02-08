module Concerns
  module ErrorHandling
    extend ActiveSupport::Concern
    included do
      unless Rails.application.config.consider_all_requests_local
        rescue_from Exception, with: :render_internal_server_error
      end
      rescue_from('Portal::CareawareApi::Services::Errors::BaseError') { |error| render_internal_server_error error }
      rescue_from('Portal::CareawareApi::Services::Errors::UnprocessableEntityError') { render_unprocessable_entity }
      rescue_from('Portal::HcoApi::Services::Errors::BaseError') { |error| render_internal_server_error error }
      rescue_from('Portal::HcoApi::Services::Errors::UnprocessableEntityError') { render_unprocessable_entity }
    end
  end
end
