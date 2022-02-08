require_relative 'screen_size_base'

module ScreenSize
  extend ScreenSizeBase

  RSpec.configure do |config|
    config.before(:each, type: :feature) do
      if RSpec.current_example.metadata[:device_size].blank?
        ScreenSize.screen_size ScreenSize.default_size
      else
        ScreenSize.screen_size RSpec.current_example.metadata[:device_size]
      end
    end
  end
end
