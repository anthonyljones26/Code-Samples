require_relative 'capybara_helper'

module CapybaraCleanRelease
  RSpec.configure do |config|
    config.before(:suite) do
      CapybaraHelper.clean_release_dir
    end
  end
end
