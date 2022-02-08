require 'capybara/rails'
require 'capybara/rspec'
require_relative 'capybara_base'

module CapybaraSetup
  extend CapybaraBase

  # registered drivers: rack_test, selenium, firefox, chrome, remote_internet_explorer
  ENV['CAPYBARA_DRIVER'] ||= 'remote_chrome'

  # local selenium hub setup; to help with remote_internet_explorer testing
  ENV['SELENIUM_SERVER'] ||= 'http://hub:4444/wd/hub'
  ENV['SELENIUM_APP_HOST'] ||= 'http://localhost:3000'

  CapybaraSetup.register_selenium_remote_driver(:firefox)
  CapybaraSetup.register_selenium_remote_driver(:chrome)
  CapybaraSetup.register_selenium_remote_driver(:internet_explorer)
  CapybaraSetup.default_driver(ENV['CAPYBARA_DRIVER'])

  RSpec.configure do |config|
    config.before(:suite) do
      CapybaraSetup.setup
    end

    config.after(:suite) do
      CapybaraSetup.teardown
    end
  end
end
