# rubocop:disable Metrics/BlockLength, Style/MixinUsage
require 'colorize'
require_relative 'task_helper'
include PortalAllergyVials::TaskHelper

# rubocop:disable Rails/RakeEnvironment
namespace :lint do
  desc 'Run rubocop as shell'
  did_fail = false
  task :rubocop do
    if sh_in_dir(root_dir, 'bundle exec rubocop -D .')
      puts 'rubocop: no issues'.colorize(:blue)
    else
      puts 'rubocop: errors/warnings found'.colorize(:red)
      did_fail = true
    end
  end

  desc 'Run slim-lint as shell'
  task :slim do
    if sh_in_dir(root_dir, 'bundle exec slim-lint app/views/')
      puts 'slim-lint: no issues'.colorize(:blue)
    else
      puts 'slim-lint: errors/warnings found'.colorize(:red)
      did_fail = true
    end
  end

  desc 'Run eslint as shell'
  task :eslint do
    sh_in_dir(root_dir, 'npm install -g eslint') unless sh_in_dir(root_dir, 'which eslint')
    if sh_in_dir(root_dir, 'eslint app/javascript/ --ext .js,.es6,.jsx')
      puts 'eslint: no issues'.colorize(:blue)
    else
      puts 'eslint: errors/warnings found'.colorize(:red)
      did_fail = true
    end
  end

  desc 'Run sass-lint as shell'
  task :sass do
    sh_in_dir(root_dir, 'npm install -g sass-lint') unless sh_in_dir(root_dir, 'which sass-lint')
    if sh_in_dir(root_dir, 'sass-lint -v -q')
      puts 'sass-lint: no issues'.colorize(:blue)
    else
      puts 'sass-lint: errors/warnings found'.colorize(:red)
      did_fail = true
    end
  end

  desc 'Run all linters [rubocop, slim, eslint, sass]'
  task lint: %i[rubocop slim eslint sass] do
    puts 'Completed all linting'.colorize(:blue)
    raise 'Linters failed.' if did_fail && ENV['raise_on_error']
  end
end
# rubocop:enable Rails/RakeEnvironment

desc 'Runs all linters. Run `rake -D lint` to see all available lint options'
task lint: ['lint:lint']

# rubocop:enable Metrics/BlockLength, Style/MixinUsage
