require 'simplecov'

module SimpleCovSetup
  SimpleCov.start 'rails' do
    add_filter 'vendor/'
    add_filter 'lib/tasks/'
    coverage_dir Rails.root.join('tmp', 'coverage')
  end
end
