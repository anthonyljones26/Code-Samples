require 'rails_helper'
require 'rake/file_utils'
include FileUtils # rubocop:disable Style/MixinUsage
include ResultsGraphingFhir # rubocop:disable Style/MixinUsage # Needed to move include outside describe

RSpec.describe 'TaskHelper' do
  context 'root_dir' do
    it 'returns root directory path' do
      expect(TaskHelper.root_dir).to eq(Rails.root.join('.'))
    end
  end

  context 'sh_in_dir' do
    it 'executes a string in a shell in the given directory' do
      expect_any_instance_of(FileUtils).to receive(:sh).with('cd root_dir && which rubocop') do |&block|
        block.call(true)
      end
      TaskHelper.sh_in_dir('root_dir', 'which rubocop')
    end

    it 'executes an array of strings in a shell in the given directory' do
      expect_any_instance_of(FileUtils).to receive(:sh).with('cd root_dir && which rubocop') do |&block|
        block.call(true)
      end
      expect_any_instance_of(FileUtils).to receive(:sh).with('cd root_dir && which slim-lint') do |&block|
        block.call(true)
      end
      TaskHelper.sh_in_dir('root_dir', ['which rubocop', 'which slim-lint'])
    end
  end
end
