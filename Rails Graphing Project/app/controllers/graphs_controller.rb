class GraphsController < ApplicationController # rubocop:disable Metrics/ClassLength
  before_action :authorize_user, only: [:graph_data]

  DEBUG_OBSERVATIONS = false # debug/mock FHIR observation service call

  def index; end

  def launch; end

  def graph_data
    bp_data = fhir_service_observation_call
    render_ok build_response(bp_data)
  rescue StandardError => e
    log_method_error(e, __method__.to_s)
    render_internal_server_error error: e
  end

  private

  def fhir_service_observation_call
    return mock_observation_call if DEBUG_OBSERVATIONS && Rails.env.development?

    @fhir_service.retrieve_observation_by_patient(
      code: (@codes['systolic'] + @codes['diastolic']),
      date: setup_date_range
    )
  end

  def build_response_entry(diastolic, systolic, source, date)
    {
      date: date,
      source: source,
      systolic: systolic&.value_quantity&.value,
      sLow: systolic&.reference_range&.first&.low&.value,
      sHigh: systolic&.reference_range&.first&.high&.value,
      diastolic: diastolic&.value_quantity&.value,
      dLow: diastolic&.reference_range&.first&.low&.value,
      dHigh: diastolic&.reference_range&.first&.high&.value
    }
  end

  def build_non_grouped_pair_entry(entry, bp_type, source)
    {
      entry: entry,
      bp_type: bp_type,
      source: source
    }
  end

  def build_response(bp_data) # rubocop:disable Metrics/AbcSize
    response = []
    non_grouped_pairs = {}

    bp_data.each do |entry|
      next unless FHIR_CONFIG['observation']['status_whitelist'].include? entry.status

      systolic = component_entry(entry, @codes['systolic'])
      diastolic = component_entry(entry, @codes['diastolic'])

      # source returns both the type (home, office, or other), referred using source[:type] and
      # its corresponding code_text_pair (i.e. ["SBP NIBP", "DBP NIBP"]), referred using source[:code_text_pair]
      source = observation_source(systolic, diastolic)

      # Should FHIR returns systolic and diastolic grouped pair together in a "component"
      if systolic && diastolic
        response.push(build_response_entry(diastolic, systolic, source[:type], entry.effective_datetime))
      else
        # Create a hash based on effective date, ssued date, and corresponding code_text_pairs
        non_grouped_pairs[entry.effective_datetime] ||= {}
        non_grouped_pairs[entry.effective_datetime][entry.issued] ||= {}
        non_grouped_pairs[entry.effective_datetime][entry.issued][source[:code_text_pair]] ||= []
        # Build an hash array of unidentified pairs with number of grouping criterias
        non_grouped_pairs[entry.effective_datetime][entry.issued][source[:code_text_pair]]
          .push(build_non_grouped_pair_entry(systolic || diastolic, systolic ? 'systolic' : 'diastolic', source[:type]))
      end
    end

    # Identifies and groups individual non-paired entries
    group_individual_entries(non_grouped_pairs, response)
    response
  end

  # Go through the array of non-grouped pairs to find a matching pair and group them if exist;
  # otherwise, keep them individual entries
  def group_individual_entries(non_grouped_pairs, response) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    non_grouped_pairs.each do |effective_datetime, issued_date| # rubocop:disable Metrics/BlockLength
      issued_date.each do |_, code_text_pairs|
        code_text_pairs.each do |_, pair|
          if pair.length == 2
            if pair[0][:bp_type] == 'diastolic' && pair[1][:bp_type] == 'systolic'
              next response.push(
                build_response_entry(pair[0][:entry], pair[1][:entry], pair[0][:source], effective_datetime)
              )
            elsif pair[1][:bp_type] == 'diastolic' && pair[0][:bp_type] == 'systolic'
              next response.push(
                build_response_entry(pair[1][:entry], pair[0][:entry], pair[0][:source], effective_datetime)
              )
            end
          end
          pair.each do |single_pair| # Keep further unidentified pairs as separate entries
            if single_pair[:bp_type] == 'diastolic'
              response.push(
                build_response_entry(single_pair[:entry], nil, single_pair[:source], effective_datetime)
              )
            else
              response.push(
                build_response_entry(nil, single_pair[:entry], single_pair[:source], effective_datetime)
              )
            end
          end
        end
      end
    end
  end

  def observation_source(systolic, diastolic)
    source = determine_source(systolic || diastolic)
    if source[:code_text_pair].blank?
      log_other_error(__method__, 'BloodPressure', "#{systolic&.code&.text} : #{diastolic&.code&.text}")
    end
    source
  end

  def determine_source(entry)
    FHIR_CONFIG['observation']['source'].each do |_source_key, source_group|
      match = source_group['code_text_pairs'].find { |code_text_pair| code_text_pair.include? entry.code.text }
      return { type: source_group['display'], code_text_pair: match } if match
    end
    { type: FHIR_CONFIG['observation']['source']['other']['display'], code_text_pair: [] }
  end

  def component_entry(entry, code)
    entry_code = entry.code.coding.select do |code_value|
      code.include?('system' => code_value.system, 'code' => code_value.code)
    end
    return entry unless entry_code.empty?

    component = entry.component.select do |component_value|
      component_code = component_value.code.coding.select do |code_value|
        code.include?('system' => code_value.system, 'code' => code_value.code)
      end
      component_code.present?
    end
    component[0]
  end

  def mock_observation_call # rubocop:disable Metrics/AbcSize
    date_regex = /\d{4}-\d{2}-\d{2}/
    date_range = setup_date_range

    # get sample data
    raw_data = File.read(Rails.root.join('spec/fixtures/fhir_data/custom', 'Observation.json'))

    # find days difference between sample data and yesterday
    reference_date = raw_data.scan(date_regex).uniq.max
    date_diff = (Date.yesterday - reference_date.to_date).to_i

    # override all dates in sample data to keep them recent
    dates = raw_data.scan(date_regex).uniq.sort
    dates.each do |date|
      raw_data.gsub!(date, (date.to_date + date_diff.days).to_s)
    end

    # replicate expected response
    observations = []
    entries = JSON.parse(raw_data)
    entries.each do |entry|
      observation = FhirServices::Observation.new(entry['resource'])
      next unless observation.effective_datetime.between?(date_range[:greater_equal], date_range[:less_equal])

      observations.push(observation)
    end
    observations
  end
end
