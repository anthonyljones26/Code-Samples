require 'portal/healthelife_api'

module Concerns
  module Authentication
    extend ActiveSupport::Concern

    included do
      before_action :require_login
    end

    private

    def session_cloud_principal
      session[ActionDispatch::Session::TokenSessionStore::PRINCIPAL]
    end

    def require_login
      return redirect_to unauthorized_url(bcs_token: session_bcs_token) if session_cloud_principal.blank?

      unless verify_session_cloud_principal
        session[:principal] = session_cloud_principal
        setup_session(setup_healthelife_persons(session_cloud_principal))
      end
      redirect_to unauthorized_url(bcs_token: session_bcs_token) unless verify_session_users
    end

    def verify_session_cloud_principal
      session_cloud_principal && session_cloud_principal == session[:principal]
    end

    def verify_session_users
      @all_users = session[:all_users].map { |user| Person.new_from_array(user) }
      @login_user = @all_users[session[:login_user_index]]
      @active_user = @all_users[session[:active_user_index]]
      @all_users && @login_user && @active_user
    rescue StandardError
      false
    end

    def get_healthelife_persons(record_id)
      healthelife_api.get_accessible_persons_with_ch_record_id(record_id)
    end

    def setup_healthelife_persons(record_id)
      persons = get_healthelife_persons(record_id).map { |person| Person.new(person) }
      persons.sort_by! { |person| [person.name] }
    rescue StandardError
      []
    end

    def healthelife_api
      @healthelife_api ||= Portal::HealthelifeApi.new(
        CC_CONFIG['client_id'],
        CC_CONFIG['client_secret'],
        CC_CONFIG['access_token_url'],
        CC_CONFIG['healthelife_base_url']
      )
    end

    def setup_session(persons)
      return if persons.blank?

      person_index = persons.find_index(&:is_user) || 0
      session[:active_user_index] = person_index
      session[:login_user_index] = person_index
      session[:all_users] = persons.map(&:to_array)
    end
  end
end
