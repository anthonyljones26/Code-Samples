module FeatureSetup
  # require all rb files in helpers directory
  Dir[Rails.root.join('spec/helpers/**/*.rb')].sort.each { |f| require f }

  RSpec.configure do |config|
    # include commonly used feature helpers
    config.include PortalAllergyVials::AuthHelper, type: :system
    config.include PortalAllergyVials::AllergyFormHelper, type: :system
  end
end
