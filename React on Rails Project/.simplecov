SimpleCov.start 'rails' do
  add_filter 'bin/'
  add_filter 'config/'
  add_filter 'coverage/'
  add_filter 'log/'
  add_filter 'node_modules/'
  add_filter 'test/'
  add_filter 'tmp/'
  add_filter 'vendor/'

  # Remove unused application base files
  add_filter do |source_file|
    source_file.lines.count < 5
  end
end
