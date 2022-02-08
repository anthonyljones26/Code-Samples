module FeatureSetup
  # require all rb files in helpers directory
  Dir[Rails.root.join('spec/helpers/**/*.rb')].each { |f| require f }

  RSpec.configure do |config|
    # include commonly used feature helpers
    config.include ResultsGraphingFhir::SessionHelper, type: :feature
    config.include ResultsGraphingFhir::TimeTravelHelper, type: :feature
    config.include ResultsGraphingFhir::VcrHelper, type: :feature
    config.include ResultsGraphingFhir::ScenarioHelper, type: :feature
    config.include ResultsGraphingFhir::FactoryHelper, type: :feature
  end
end
