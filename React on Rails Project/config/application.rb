require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
# require 'active_record/railtie'
# require 'active_storage/engine'
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

module PortalAllergyVials
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    Dotenv.load "#{Rails.root}/config/env/#{Rails.env}.env"
    Dotenv.load "#{Rails.root}/config/env/tide/credentials.env"

    # set default time zone
    ENV['TIME_ZONE'] ||= 'Central Time (US & Canada)'
    config.time_zone = ENV['TIME_ZONE']
  end
end

APP_CONFIG = YAML.load_file('config/app.yml')[Rails.env]
IDX_CONFIG = YAML.safe_load(ERB.new(File.read('config/idx.yml')).result, [], [], true)[Rails.env]
CA_CONFIG = YAML.safe_load(ERB.new(File.read('config/careaware.yml')).result, [], [], true)[Rails.env]
CC_CONFIG = YAML.safe_load(ERB.new(File.read('config/cerrnercare.yml')).result, [], [], true)[Rails.env]
MU_CONFIG = YAML.load_file('config/muhealtheportal.yml')[Rails.env]
REDIS_CONFIG = YAML.safe_load(ERB.new(File.read('config/redis.yml')).result, [], [], true)[Rails.env]

DEX_CONFIG = YAML.load_file('config/dex_framework_mock.yml')[Rails.env] if Rails.env.test? || Rails.env.development?
