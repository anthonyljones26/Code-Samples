module CapybaraHelper
  REGEX_SAFE_FILENAME = /[^0-9A-Za-z.\-]/.freeze

  def self.release_dir
    Rails.root.join(
      'tmp',
      'capybara',
      PortalAllergyVials::Application::VERSION.gsub(REGEX_SAFE_FILENAME, '_')
    )
  end

  def self.failed_dir
    Rails.root.join(
      'tmp',
      'screenshots'
    )
  end

  def self.clean_release_dir
    driver = Capybara.current_driver
    browser_dir = release_dir.join(
      driver.to_s
    )
    FileUtils.remove_dir(browser_dir) if browser_dir.directory?
    failed_dir = failed_dir()
    FileUtils.remove_dir(failed_dir) if failed_dir.directory?
  end

  def self.take_screenshot(page)
    metadata = RSpec.current_example.metadata
    metadata_descriptions = metadata_descriptions(metadata)
    directory = metadata_descriptions.shift.gsub(REGEX_SAFE_FILENAME, '_')
    description = metadata_descriptions.join('-').gsub(REGEX_SAFE_FILENAME, '_')
    driver = Capybara.current_driver
    timestamp = Time.now.strftime('%Y%m%d%H%M%S%L')
    release_dir = release_dir()
    screenshot_name = release_dir.join(
      driver.to_s,
      directory,
      "#{description}.#{timestamp}.png"
    )
    page.save_screenshot(screenshot_name, full: true)
  end

  def self.metadata_descriptions(metadata)
    descriptions = [metadata[:description]]

    group_metadata = metadata.fetch(:example_group) { metadata[:parent_example_group] }
    return descriptions unless group_metadata

    loop do
      descriptions.unshift(group_metadata[:description])
      break unless (group_metadata = group_metadata[:parent_example_group])
    end

    descriptions
  end
end
