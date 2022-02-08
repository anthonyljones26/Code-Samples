module ResultsGraphingFhir
  module FactoryHelper # rubocop:disable Metrics/ModuleLength
    HOME = 'SBP Home'.freeze
    OFFICE = 'SBP NIBP'.freeze
    RANGE_VALUES = {
      one_day: 1,
      one_week: 2,
      one_month: 3,
      two_months: 4,
      six_months: 5,
      one_year: 6,
      two_years: 7
    }.freeze

    def mock_observation_one_day
      [
        FactoryBot.build(:observation, source: HOME, sbp: 103.0, dbp: 63.0, days_ago: 1)
      ]
    end

    def mock_observation_one_week
      [
        FactoryBot.build(:observation, source: HOME, sbp: 100.0, dbp: 60.0, days_ago: 5),
        FactoryBot.build(:observation, source: HOME, sbp: 110.0, dbp: 66.0, days_ago: 7)
      ]
    end

    def mock_observation_one_month
      [
        FactoryBot.build(:observation, source: OFFICE, sbp: 90.0, dbp: 55.0, days_ago: 10),
        FactoryBot.build(:observation, source: HOME, sbp: 95.0, dbp: 70.0, days_ago: 11),
        FactoryBot.build(:observation, source: HOME, sbp: 70.0, dbp: 50.0, days_ago: 14),
        FactoryBot.build(:observation, source: OFFICE, sbp: 120.0, dbp: 115.0, days_ago: 20),
        FactoryBot.build(:observation, sbp: 90.0, dbp: 55.0, days_ago: 30)
      ]
    end

    def mock_observation_two_months
      [
        FactoryBot.build(:observation, source: HOME, sbp: 95.0, dbp: 70.0, days_ago: 41),
        FactoryBot.build(:observation, source: HOME, sbp: 100.0, dbp: 80.0, days_ago: 50),
        FactoryBot.build(:observation, sbp: 120.0, dbp: 77.0, days_ago: 55),
        FactoryBot.build(:observation, source: HOME, sbp: 105.0, dbp: 60.0, days_ago: 60),
        FactoryBot.build(:observation, source: HOME, sbp: nil, dbp: 60.0, days_ago: 55),
        FactoryBot.build(:observation, source: HOME, sbp: 95.0, dbp: nil, days_ago: 58)
      ]
    end

    def mock_observation_six_months
      [
        FactoryBot.build(:observation, source: HOME, sbp: 70.0, dbp: 50.0, days_ago: 75),
        FactoryBot.build(:observation, source: OFFICE, sbp: 135.0, dbp: 85.0, days_ago: 100)
      ]
    end

    def mock_observation_one_year
      [
        FactoryBot.build(:observation, source: OFFICE, sbp: 105.0, dbp: 75.0, days_ago: 200),
        FactoryBot.build(:observation, source: OFFICE, sbp: 98.0, dbp: 70.0, days_ago: 300),
        FactoryBot.build(:observation, sbp: 90.0, dbp: 45.0, days_ago: 360)
      ]
    end

    def mock_observation_two_years
      [
        FactoryBot.build(:observation, source: HOME, sbp: 130.0, dbp: 70.0, days_ago: 365),
        FactoryBot.build(:observation, source: HOME, sbp: 133.0, dbp: 76.0, days_ago: 400),
        FactoryBot.build(:observation, source: OFFICE, sbp: 140.0, dbp: 80.0, days_ago: 450),
        FactoryBot.build(:observation, source: HOME, sbp: 145.0, dbp: 85.0, days_ago: 480),
        FactoryBot.build(:observation, source: HOME, sbp: 120.0, dbp: 90.0, days_ago: 500)
      ]
    end

    def mock_observations_range(date_range = :two_months) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      mock_data = []
      mock_data.concat(mock_observation_one_day) if RANGE_VALUES[date_range] >= RANGE_VALUES[:one_day]
      mock_data.concat(mock_observation_one_week) if RANGE_VALUES[date_range] > RANGE_VALUES[:one_day]
      mock_data.concat(mock_observation_one_month) if RANGE_VALUES[date_range] > RANGE_VALUES[:one_week]
      mock_data.concat(mock_observation_two_months) if RANGE_VALUES[date_range] > RANGE_VALUES[:one_month]
      mock_data.concat(mock_observation_six_months) if RANGE_VALUES[date_range] > RANGE_VALUES[:two_months]
      mock_data.concat(mock_observation_one_year) if RANGE_VALUES[date_range] > RANGE_VALUES[:six_months]
      mock_data.concat(mock_observation_two_years) if RANGE_VALUES[date_range] > RANGE_VALUES[:one_year]

      mock_data
    end

    def no_other_data(date_range = :two_months)
      mock_data = mock_observations_range(date_range)
      mock_data.reject { |bp| bp.component[0].code.text == 'other' }
    end

    def high_bp_data(date_range = :two_months)
      mock_data = mock_observations_range(date_range)
      mock_data.concat([FactoryBot.build(:observation, source: HOME, sbp: 220.0, dbp: 90.0, days_ago: 45)])
    end

    def pair_bp_data
      [
        FactoryBot.build(
          :observation, :use_date, source: HOME, sbp: nil, dbp: 63.0, exact_date: '2013-03-10T16:00:00.000Z'
        ),
        FactoryBot.build(
          :observation, :use_date, source: HOME, sbp: 180.0, dbp: nil, exact_date: '2013-03-10T16:00:00.000Z'
        ),
        FactoryBot.build(
          :observation, :use_date, source: HOME, sbp: nil, dbp: 73.0, exact_date: '2013-03-12T18:00:00.000Z'
        ),
        FactoryBot.build(
          :observation, :use_date, source: HOME, sbp: 150.0, dbp: nil, exact_date: '2013-03-12T18:20:00.000Z'
        )
      ]
    end

    def mock_medication_orders # rubocop:disable Metrics/MethodLength
      [
        # Medication A, is a basic medication entry
        FactoryBot.build(:medication_order, id: '1', name: 'Medication A', dose_strength: 1, start_date: 2.years.ago),
        # Medication E, will have a nested medication bar on the graph
        FactoryBot.build(
          :medication_order,
          id: '12',
          name: 'Medication E',
          dose_strength: 5,
          start_date: 3.years.ago,
          end_date: nil
        ),
        FactoryBot.build(
          :medication_order,
          id: '13',
          name: 'Medication E',
          dose_strength: 6,
          start_date: 1.years.ago,
          end_date: 2.months.ago
        ),
        # Medication C, has full tooltip data
        FactoryBot.build(
          :medication_order,
          id: '3',
          name: 'Medication C',
          dose_strength: 3,
          start_date: 2.months.ago,
          status: 'completed'
        ),
        # Medication G, is merge by case-insensitive names and same start and end date,
        FactoryBot.build(:medication_order, id: '16', name: 'MEDICATION G', end_date: nil),
        FactoryBot.build(:medication_order, id: '17', name: 'Medication G', end_date: nil),
        # Medication H, has partial data
        FactoryBot.build(:medication_order, :partial, id: '18', name: 'Medication H'),
        # Medication J, is merge by case-insensitive names and same start and end date,
        # tooltip is separated by strength differences
        FactoryBot.build(
          :medication_order,
          id: '22',
          dose_strength: 1,
          name: 'MEDICATION J',
          start_date: 3.years.ago,
          end_date: nil
        ),
        FactoryBot.build(
          :medication_order,
          id: '23',
          dose_strength: 2,
          name: 'Medication J',
          start_date: 3.years.ago,
          end_date: nil
        )
      ]
    end

    def mock_medication_statements # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      [
        # Medication A, is a basic medication entry
        FactoryBot.build(
          :medication_statement,
          id: '5',
          name: 'Medication A',
          dose_strength: 1,
          start_date: 2.years.ago
        ),
        # Medication E, will have a nested medication bar on the graph
        FactoryBot.build(
          :medication_statement,
          :outpatient,
          id: '12',
          name: 'Medication E',
          dose_strength: 5,
          start_date: 3.years.ago, end_date: nil
        ),
        # Medication C, has full tooltip data
        FactoryBot.build(
          :medication_statement,
          :home_med,
          id: '7',
          name: 'Medication C',
          dose_strength: 3,
          start_date: 2.months.ago,
          status: 'completed',
          order_id: 3
        ),
        # Medication B, has a start date the extens beyond the 2 year graph
        FactoryBot.build(
          :medication_statement,
          :outpatient,
          id: '6',
          name: 'Medication B',
          dose_strength: 2,
          start_date: 40.days.ago,
          end_date: 10.days.ago,
          not_taken: true
        ),
        # Medication D, basic entry with an inpatient catagory
        FactoryBot.build(
          :medication_statement,
          :rxcui,
          id: '8',
          name: 'Medication D',
          start_date: 40.days.ago,
          end_date: 8.days.ago
        ),
        # Medication F, different strengths in separate bars on the same line that don't overlap
        FactoryBot.build(
          :medication_statement,
          id: '14',
          name: 'Medication F - very very long medication name',
          dose_strength: 7,
          start_date: 30.days.ago,
          end_date: nil
        ),
        FactoryBot.build(
          :medication_statement,
          id: '15',
          name: 'Medication F - very very long medication name',
          dose_strength: 10,
          start_date: 1.years.ago,
          end_date: 60.days.ago
        ),
        # Medication I, has three tooltip entries
        FactoryBot.build(
          :medication_statement,
          id: '19',
          dose_strength: 10,
          name: 'Medication I',
          start_date: 400.days.ago,
          end_date: 3.days.ago
        ),
        FactoryBot.build(
          :medication_statement,
          id: '20',
          dose_strength: 10,
          name: 'Medication I',
          start_date: 399.days.ago,
          end_date: 2.days.ago
        ),
        FactoryBot.build(
          :medication_statement,
          id: '21',
          dose_strength: 10,
          name: 'Medication I',
          start_date: 398.days.ago,
          end_date: 1.days.ago
        )
      ]
    end

    def mock_medication_data
      allow_any_instance_of(FhirServices::Client)
        .to receive(:retrieve_medication_orders_by_patient)
        .and_return(mock_medication_orders)

      allow_any_instance_of(FhirServices::Client)
        .to receive(:retrieve_medication_statements_by_patient)
        .and_return(mock_medication_statements)
    end

    def mock_factory_data
      allow_any_instance_of(FhirServices::Client)
        .to receive(:retrieve_observation_by_patient)
        .and_return(mock_observations_range)

      mock_medication_data
    end

    def mock_no_data
      allow_any_instance_of(FhirServices::Client)
        .to receive(:retrieve_observation_by_patient)
        .and_return([])

      allow_any_instance_of(FhirServices::Client)
        .to receive(:retrieve_medication_orders_by_patient)
        .and_return([])

      allow_any_instance_of(FhirServices::Client)
        .to receive(:retrieve_medication_statements_by_patient)
        .and_return([])
    end

    def mock_observation_data(date_range, filter_option)
      if filter_option == :modified_data
        allow_any_instance_of(FhirServices::Client)
          .to receive(:retrieve_observation_by_patient)
          .and_return(no_other_data(date_range))
      else
        allow_any_instance_of(FhirServices::Client)
          .to receive(:retrieve_observation_by_patient)
          .and_return(mock_observations_range(date_range))
      end
    end

    def mock_no_other_data
      allow_any_instance_of(FhirServices::Client)
        .to receive(:retrieve_observation_by_patient)
        .and_return(no_other_data)

      mock_medication_data
    end

    def mock_high_bp_data
      allow_any_instance_of(FhirServices::Client)
        .to receive(:retrieve_observation_by_patient)
        .and_return(high_bp_data)

      mock_medication_data
    end

    def mock_pair_bp_data
      allow_any_instance_of(FhirServices::Client)
        .to receive(:retrieve_observation_by_patient)
        .and_return(pair_bp_data)

      mock_medication_data
    end
  end
end
