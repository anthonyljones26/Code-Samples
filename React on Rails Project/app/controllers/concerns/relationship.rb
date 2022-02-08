module Concerns
  module Relationship
    extend ActiveSupport::Concern

    included do
      before_action :require_relationship
    end

    private

    def require_relationship
      return if verify_relationship

      redirect_to no_relationship_url(bcs_token: session_bcs_token)
    end

    def verify_relationship
      @active_user&.mill_person_id.present?
    end
  end
end
