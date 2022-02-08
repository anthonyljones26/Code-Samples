module CapybaraBase
  def register_selenium_local_driver(browser)
    Capybara.register_driver browser.to_sym do |app|
      Capybara::Selenium::Driver.new(app, browser: browser)
    end
  end

  def register_selenium_remote_driver(browser)
    Capybara.register_driver "remote_#{browser}".to_sym do |app|
      Capybara::Selenium::Driver.new(
        app,
        browser: :remote,
        url: ENV['SELENIUM_SERVER'],
        desired_capabilities: browser
      )
    end
  end

  def default_driver(driver)
    Capybara.default_driver = driver.to_sym
  end

  def setup
    Capybara.app_host = ENV['SELENIUM_APP_HOST']
    Capybara.server_host = '0.0.0.0' # NOTE: set if capybara starting server; must line up with fhir client definition
    Capybara.server_port = '3000' # NOTE: set if capybara starting server; must line up with fhir client definition
    Capybara.default_max_wait_time = 10
  end

  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end
