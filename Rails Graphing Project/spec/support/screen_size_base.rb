module ScreenSizeBase
  SCREENS = {
    small: { width: 640, height: 1380 },
    medium: { width: 960, height: 1380 },
    large: { width: 1024, height: 1380 },
    xlarge: { width: 1440, height: 1380 }
  }.freeze

  def default_size
    'large'
  end

  def screen_size(size)
    screen_size = SCREENS[size.to_sym]
    raise "Invalid screen size #{size}. It should be :small, :medium, :large, or :xlarge" if screen_size.blank?

    return unless Capybara.current_session.driver.browser.respond_to? 'manage'

    Capybara.current_session.driver.browser.manage.window.resize_to(screen_size[:width], screen_size[:height])
  end
end
