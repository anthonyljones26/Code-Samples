require 'rails_helper'

RSpec.describe ResultsGraphingFhir::Logger do
  subject { Class.new { include ResultsGraphingFhir::Logger; def session; end }.new } # rubocop:disable Style/Semicolon

  context 'Logger #event_logger' do
    it 'should log - in all fields except for provider' do
      expect(Rails.configuration.event_logger).to receive(:info).with(' [-] [-] [-] [-]')
      subject.event_logger(nil, nil, nil, nil)
    end

    it 'should log mock data for all fields' do
      expect(Rails.configuration.event_logger).to receive(:info)
        .with(' [1234] [Navigation] [ResultsGraphing] [Visited]')
      subject.event_logger('1234', 'Navigation', 'ResultsGraphing', 'Visited')
    end
  end

  context 'no user session' do
    it 'should log - for provider' do
      allow_any_instance_of(subject.class).to receive(:session).and_return({})

      expect(Rails.configuration.event_logger).to receive(:info).with(' [-] [Navigation] [ResultsGraphing] [Visited]')
      subject.log_user_event('Navigation', 'ResultsGraphing', 'Visited')
      allow_any_instance_of(subject.class).to receive(:session).and_call_original
    end
  end

  context 'valid user session' do
    it 'should log 1234 for provider' do
      allow_any_instance_of(subject.class).to receive(:session).and_return('token_response' => { 'user' => '1234' })

      expect(Rails.configuration.event_logger).to receive(:info)
        .with(' [1234] [Navigation] [ResultsGraphing] [Visited]')
      subject.log_user_event('Navigation', 'ResultsGraphing', 'Visited')
      allow_any_instance_of(subject.class).to receive(:session).and_call_original
    end
  end

  context 'log method error ' do
    it 'should log - in all fields' do
      allow_any_instance_of(subject.class).to receive(:session).and_return({})

      expect(Rails.configuration.error_logger).to receive(:error).with(' [-] [-.-] [NilClass] [-]')
      subject.log_method_error(nil, nil)
      allow_any_instance_of(subject.class).to receive(:session).and_call_original
    end

    it 'should log mock data for all fields' do
      allow_any_instance_of(subject.class).to receive(:session).and_return('token_response' => { 'user' => '1234' })

      expect(Rails.configuration.error_logger).to receive(:error)
        .with(' [1234] [-.test_spec] [RuntimeError] [successfulTest]')
      subject.log_method_error(RuntimeError.new('successfulTest'), 'test_spec')
      allow_any_instance_of(subject.class).to receive(:session).and_call_original
    end
  end

  context 'log differences between med_statement and med_order ' do
    it 'should log - in all fields' do
      expect(Rails.configuration.difference_logger).to receive(:info).with(' [-] [-] [-]')
      subject.log_medication_difference(nil, nil, nil)
    end

    it 'should log mock data for all fields' do
      expect(Rails.configuration.difference_logger).to receive(:info)
        .with(' [start_date] [2011-12-12] [2011-06-06]')
      subject.difference_logger('start_date', '2011-12-12', '2011-06-06')
    end
  end

  context 'log when other data exists ' do
    it 'should log - in all fields' do
      allow_any_instance_of(subject.class).to receive(:session).and_return({})
      expect(Rails.configuration.error_logger).to receive(:error).with(' [-] [-.-] [-] [-]')
      subject.log_other_error(nil, nil, nil)
    end

    it 'should log mock data for all fields' do
      expect(Rails.configuration.error_logger).to receive(:error)
        .with(' [1234] [method] [BloodPressure] [Home : Office]')
      subject.error_logger('1234', 'method', 'BloodPressure', 'Home : Office')
    end
  end
end
