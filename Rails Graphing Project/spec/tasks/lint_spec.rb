require 'rails_helper'
RSpec.describe 'lint tasks', type: :task do
  include ResultsGraphingFhir

  before(:each) do
    @dir_name = 'dir_name'
    allow_any_instance_of(TaskHelper).to receive(:root_dir).and_return(@dir_name)
  end

  context 'lint:rubocop' do
    after(:each) do
      expect { invoke_task('lint:rubocop') }.not_to raise_error
    end

    it 'invokes rubocop with no issues found' do
      expect_any_instance_of(TaskHelper).to(
        receive(:sh_in_dir).with(@dir_name, 'bundle exec rubocop -D .').and_return(true)
      )
      expect_any_instance_of(Kernel).to receive(:puts).with(Regexp.new('rubocop: no issues'))
    end

    it 'invokes rubocop with errors/warnings found' do
      expect_any_instance_of(TaskHelper).to(
        receive(:sh_in_dir).with(@dir_name, 'bundle exec rubocop -D .').and_return(false)
      )
      expect_any_instance_of(Kernel).to receive(:puts).with(Regexp.new('rubocop: errors/warnings found'))
    end
  end

  context 'lint:slim' do
    after(:each) do
      expect { invoke_task('lint:slim') }.not_to raise_error
    end

    it 'invokes slim-lint with no issues found' do
      expect_any_instance_of(TaskHelper).to(
        receive(:sh_in_dir).with(@dir_name, 'bundle exec slim-lint app/views/').and_return(true)
      )
      expect_any_instance_of(Kernel).to receive(:puts).with(Regexp.new('slim-lint: no issues'))
    end

    it 'invokes slim-lint with errors/warnings found' do
      expect_any_instance_of(TaskHelper).to(
        receive(:sh_in_dir).with(@dir_name, 'bundle exec slim-lint app/views/').and_return(false)
      )
      expect_any_instance_of(Kernel).to receive(:puts).with(Regexp.new('slim-lint: errors/warnings found'))
    end
  end

  context 'lint:eslint' do
    after(:each) do
      expect { invoke_task('lint:eslint') }.not_to raise_error
    end

    context 'when eslint not installed' do
      before(:each) do
        expect_any_instance_of(TaskHelper).to receive(:sh_in_dir).with(@dir_name, 'which eslint').and_return(false)
        expect_any_instance_of(TaskHelper).to(
          receive(:sh_in_dir).with(@dir_name, 'npm install -g eslint').and_return(true)
        )
      end

      it 'invokes eslint with no issues found' do
        expect_any_instance_of(TaskHelper).to(
          receive(:sh_in_dir).with(@dir_name, 'eslint app/assets/javascripts/ --ext .js,.es6').and_return(true)
        )
        expect_any_instance_of(Kernel).to receive(:puts).with(Regexp.new('eslint: no issues'))
      end

      it 'invokes eslint with errors/warnings found' do
        expect_any_instance_of(TaskHelper).to(
          receive(:sh_in_dir).with(@dir_name, 'eslint app/assets/javascripts/ --ext .js,.es6').and_return(false)
        )
        expect_any_instance_of(Kernel).to receive(:puts).with(Regexp.new('eslint: errors/warnings found'))
      end
    end

    context 'when eslint is installed' do
      before(:each) do
        expect_any_instance_of(TaskHelper).to receive(:sh_in_dir).with(@dir_name, 'which eslint').and_return(true)
        expect_any_instance_of(TaskHelper).not_to receive(:sh_in_dir).with(@dir_name, 'npm install -g eslint')
      end

      it 'invokes eslint with no issues found' do
        expect_any_instance_of(TaskHelper).to(
          receive(:sh_in_dir).with(@dir_name, 'eslint app/assets/javascripts/ --ext .js,.es6').and_return(true)
        )
        expect_any_instance_of(Kernel).to receive(:puts).with(Regexp.new('eslint: no issues'))
      end

      it 'invokes eslint with errors/warnings found' do
        expect_any_instance_of(TaskHelper).to(
          receive(:sh_in_dir).with(@dir_name, 'eslint app/assets/javascripts/ --ext .js,.es6').and_return(false)
        )
        expect_any_instance_of(Kernel).to receive(:puts).with(Regexp.new('eslint: errors/warnings found'))
      end
    end
  end

  context 'lint:sass' do
    after(:each) do
      expect { invoke_task('lint:sass') }.not_to raise_error
    end

    context 'when sass-lint not installed' do
      before(:each) do
        expect_any_instance_of(TaskHelper).to receive(:sh_in_dir).with(@dir_name, 'which sass-lint').and_return(false)
        expect_any_instance_of(TaskHelper).to(
          receive(:sh_in_dir).with(@dir_name, 'npm install -g sass-lint').and_return(true)
        )
      end

      it 'invokes sass-lint with no issues found' do
        expect_any_instance_of(TaskHelper).to receive(:sh_in_dir).with(@dir_name, 'sass-lint -v -q').and_return(true)
        expect_any_instance_of(Kernel).to receive(:puts).with(Regexp.new('sass-lint: no issues'))
      end

      it 'invokes sass-lint with errors/warnings found' do
        expect_any_instance_of(TaskHelper).to receive(:sh_in_dir).with(@dir_name, 'sass-lint -v -q').and_return(false)
        expect_any_instance_of(Kernel).to receive(:puts).with(Regexp.new('sass-lint: errors/warnings found'))
      end
    end

    context 'when sass-lint is installed' do
      before(:each) do
        expect_any_instance_of(TaskHelper).to receive(:sh_in_dir).with(@dir_name, 'which sass-lint').and_return(true)
        expect_any_instance_of(TaskHelper).not_to receive(:sh_in_dir).with(@dir_name, 'npm install -g sass-lint')
      end

      it 'invokes sass-lint with no issues found' do
        expect_any_instance_of(TaskHelper).to receive(:sh_in_dir).with(@dir_name, 'sass-lint -v -q').and_return(true)
        expect_any_instance_of(Kernel).to receive(:puts).with(Regexp.new('sass-lint: no issues'))
      end

      it 'invokes sass-lint with errors/warnings found' do
        expect_any_instance_of(TaskHelper).to receive(:sh_in_dir).with(@dir_name, 'sass-lint -v -q').and_return(false)
        expect_any_instance_of(Kernel).to receive(:puts).with(Regexp.new('sass-lint: errors/warnings found'))
      end
    end
  end

  context 'lint:lint and lint' do
    before(:each) do
      expect_any_instance_of(TaskHelper).to(
        receive(:sh_in_dir).with(@dir_name, 'bundle exec rubocop -D .').and_return(true)
      )
      expect_any_instance_of(TaskHelper).to(
        receive(:sh_in_dir).with(@dir_name, 'bundle exec slim-lint app/views/').and_return(true)
      )
      expect_any_instance_of(TaskHelper).to receive(:sh_in_dir).with(@dir_name, 'which eslint').and_return(true)
      expect_any_instance_of(TaskHelper).to(
        receive(:sh_in_dir).with(@dir_name, 'eslint app/assets/javascripts/ --ext .js,.es6').and_return(true)
      )
      expect_any_instance_of(TaskHelper).to receive(:sh_in_dir).with(@dir_name, 'which sass-lint').and_return(true)
      expect_any_instance_of(TaskHelper).to receive(:sh_in_dir).with(@dir_name, 'sass-lint -v -q').and_return(true)

      expect_any_instance_of(Kernel).to receive(:puts).with(Regexp.new('rubocop: no issues'))
      expect_any_instance_of(Kernel).to receive(:puts).with(Regexp.new('slim-lint: no issues'))
      expect_any_instance_of(Kernel).to receive(:puts).with(Regexp.new('eslint: no issues'))
      expect_any_instance_of(Kernel).to receive(:puts).with(Regexp.new('sass-lint: no issues'))
      expect_any_instance_of(Kernel).to receive(:puts).with(Regexp.new('Completed all linting'))
    end

    it 'invokes all linters for lint:lint' do
      expect { invoke_task('lint:lint') }.not_to raise_error
    end

    it 'invokes all linters for lint' do
      expect { invoke_task('lint') }.not_to raise_error
    end
  end

  context 'lint:lint prerequisites' do
    it 'has prerequisite tasks' do
      prerequisites = task_prerequisites('lint:lint')
      expect(prerequisites).to match_array(['lint:rubocop', 'lint:slim', 'lint:eslint', 'lint:sass'])
    end
  end

  context 'lint prerequisites' do
    it 'has prerequisite tasks' do
      prerequisites = task_prerequisites('lint')
      expect(prerequisites).to match_array(['lint:lint'])
    end
  end

  private

  def invoke_task(task)
    task = Rake::Task[task]
    # Ensure task is re-enabled, as rake tasks by default are disabled after running once within a process
    task.reenable
    task.all_prerequisite_tasks.each(&:reenable)
    task.invoke
  end

  def task_prerequisites(task)
    prerequisites = []
    Rake::Task[task].prerequisite_tasks.each do |req|
      prerequisites << req.to_s
    end
    prerequisites
  end
end
