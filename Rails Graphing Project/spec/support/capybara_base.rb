require 'headless'

module CapybaraBase
  def register_selenium_local_driver(browser)
    Capybara.register_driver browser.to_sym do |app|
      Capybara::Selenium::Driver.new(app, browser: browser)
    end
  end

  def register_selenium_remote_driver(browser)
    Capybara.register_driver "remote_#{browser}".to_sym do |app|
      Capybara::Selenium::Driver.new(app, browser: :remote, url: ENV['SELENIUM_SERVER'], desired_capabilities: browser)
    end
  end

  def default_driver(driver)
    Capybara.default_driver = driver.to_sym
  end

  def setup
    Capybara.app_host = nil # NOTE: set if server already running; e.g. 'http://localhost:3000'
    Capybara.app_host = ENV['SELENIUM_APP_HOST'] if remote?
    Capybara.server_host = '0.0.0.0' # NOTE: set if capybara starting server; must line up with fhir client definition
    Capybara.server_port = '3000' # NOTE: set if capybara starting server; must line up with fhir client definition
    Capybara.default_max_wait_time = 10

    return unless headless?

    @headless = Headless.new(display: 99, autopick: true, reuse: false, destroy_at_exit: true)
    @headless.start
  end

  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
    Capybara.app_host = nil

    return unless headless?

    @headless.destroy
  end

  def remote?
    Capybara.current_driver.to_s.start_with? 'remote_'
  end

  def headless?
    !remote? && !Gem.win_platform?
  end
end
