module CapybaraHelper
  REGEX_SAFE_FILENAME = /[^0-9A-Za-z.\-]/.freeze

  def self.release_dir
    Rails.root.join(
      'tmp',
      'capybara',
      ResultsGraphingFhir::Application::RELEASE_VERSION.gsub(REGEX_SAFE_FILENAME, '_')
    )
  end

  def self.clean_release_dir
    release_dir = release_dir()
    FileUtils.remove_dir(release_dir) if release_dir.directory?
  end

  def self.take_screenshot(page)
    metadata = RSpec.current_example.metadata
    metadata_descriptions = metadata_descriptions(metadata)
    directory = metadata_descriptions.shift.gsub(REGEX_SAFE_FILENAME, '_')
    description = metadata_descriptions.join('-').gsub(REGEX_SAFE_FILENAME, '_')
    driver = Capybara.current_driver
    size = metadata[:device_size].blank? ? ScreenSize.default_size : metadata[:device_size]
    timestamp = Time.now.strftime('%Y%m%d%H%M%S%L')
    release_dir = release_dir()
    screenshot_name = release_dir.join(
      directory,
      "#{description}.#{driver}.#{size}.#{timestamp}.png"
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
