require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
# require 'active_record/railtie'
require 'action_controller/railtie'
# require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'
require 'rails/test_unit/railtie'
require 'dotenv'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ResultsGraphingFhir
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # load environment variables
    Dotenv.load "#{Rails.root}/config/env/#{Rails.env}.env"
    Dotenv.load "#{Rails.root}/config/env/tide/credentials.env"
  end
end

# Load app config vars (loaded here so we can use values in initializers)
begin
  # does run ERB in yaml file
  FHIR_CLIENTS_CONFIG = YAML.safe_load(ERB.new(File.read('config/fhir_clients.yml')).result, [], [], true)[Rails.env]
  # does not run ERB in yaml file
  FHIR_CONFIG = YAML.load_file('config/fhir.yml')[Rails.env]
  GRAPH_CONFIG = YAML.load_file('config/graph.yml')[Rails.env]
  REDIS_CONFIG = YAML.load_file('config/redis.yml')[Rails.env]
  SECRETS_CONFIG = YAML.load_file('config/secrets.yml')[Rails.env]
rescue StandardError => e
  raise e
end
