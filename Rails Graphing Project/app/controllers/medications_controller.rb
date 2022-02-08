class MedicationsController < ApplicationController # rubocop:disable Metrics/ClassLength
  before_action :authorize_user, only: [:graph_data]

  # http://unitsofmeasure.org/ucum.html#section-Base-Units
  TIMING_CODE_XREF = {
    'min' => 'minute',
    'h' => 'hour',
    'd' => 'day',
    'a' => 'year',
    'wk' => 'week',
    'mo' => 'month'
  }.freeze

  def graph_data
    @date_range = setup_date_range

    threads = {}
    threads[:statements] = Thread.new { retrieve_medication_statements }
    threads[:orders] = Thread.new { retrieve_medication_orders }

    statements = threads[:statements].value
    orders = threads[:orders].value

    return render_ok build_response(statements, orders) if statements && orders

    render_internal_server_error error: 'Failed to retrieve medication statements or medication orders'
  rescue StandardError => e
    log_method_error(e, __method__.to_s)
    render_internal_server_error error: e
  end

  private

  def retrieve_medication_statements
    @fhir_service.retrieve_medication_statements_by_patient(
      date: @date_range,
      status: FHIR_CONFIG['medication_statement']['status_whitelist']&.join(',')
    )
  rescue FhirServices::BaseError => e
    log_method_error(e, __method__.to_s)
    nil
  end

  def retrieve_medication_orders
    @fhir_service.retrieve_medication_orders_by_patient(
      date: @date_range,
      status: FHIR_CONFIG['medication_order']['status_whitelist']&.join(',')
    )
  rescue FhirServices::BaseError => e
    log_method_error(e, __method__.to_s)
    nil
  end

  def build_response(medication_statements, medication_orders)
    response = []
    order_hash = {}

    medication_orders.each do |entry|
      med_order = build_medication_entry(entry)
      order_hash[med_order[:id]] = med_order if med_order[:id]
    end

    medication_statements.each do |entry|
      med_statement = build_medication_entry(entry)
      merge_medications(med_statement, order_hash)
      response.push(med_statement) if valid_medication?(med_statement)
    end

    order_hash.each do |_key, med_order|
      next if med_order[:order_reference_used]

      response.push(med_order) if valid_medication?(med_order)
    end

    apply_external_data(response)
    response.map { |medication| medication_to_json(medication) }
  end

  def build_medication_entry(medication)
    dosage_info = get_dosage_info(medication, get_medication_dates(medication))
    {
      id: medication&.id,
      rxcui: medication&.medication.try(:coding)&.first&.code,
      medication: get_medication_name(medication),
      start_date: dosage_info[:start_date],
      end_date: dosage_info[:end_date],
      was_not_taken: medication.is_a?(FhirServices::MedicationStatement) ? medication.was_not_taken : nil,
      strength: dosage_info[:strength],
      quantity: dosage_info[:quantity],
      frequency: dosage_info[:frequency],
      additional_instructions: dosage_info[:additional_instructions],
      order_references: get_medication_order_references(medication),
      order_reference_used: false,
      category: dosage_info[:category]

    }
  end

  def merge_medications(med_statement, order_hash)
    return unless med_statement[:order_references].present?

    med_statement[:order_references].each do |order_reference|
      next unless order_hash[order_reference]

      check_differences(med_statement, order_hash[order_reference])
      merge_medication_details(med_statement, order_hash[order_reference])
      order_hash[order_reference][:order_reference_used] = true
    end
  end

  def merge_medication_details(med_statement, med_order)
    med_statement[:medication] ||= med_order[:medication]
    med_statement[:start_date] ||= med_order[:start_date]
    med_statement[:end_date] ||= med_order[:end_date]
    med_statement[:strength] ||= med_order[:strength]
    med_statement[:quantity] ||= med_order[:quantity]
    med_statement[:frequency] ||= med_order[:frequency]
    med_statement[:additional_instructions] ||= med_order[:additional_instructions]
  end

  def check_differences(med_statement, med_order)
    FHIR_CONFIG['difference_log'].map(&:to_sym).each do |key|
      unless med_statement.dig(key).to_s&.eql? med_order.dig(key).to_s
        log_medication_difference(key, med_statement, med_order)
      end
    end
  end

  def medication_to_json(medication)
    {
      id: medication[:id],
      medication: medication[:medication],
      startDate: medication[:start_date],
      endDate: medication[:end_date],
      wasNotTaken: medication[:was_not_taken],
      strength: medication[:strength],
      quantity: medication[:quantity],
      frequency: medication[:frequency],
      additionalInstructions: medication[:additional_instructions],
      category: medication[:category]
    }
  end

  def get_medication_name(medication)
    if medication.medication.is_a? FhirServices::CodeableConcept
      get_medication_name_from_codeable_concept(medication.medication)
    elsif medication.medication.is_a? FhirServices::Reference
      get_medication_name_from_reference(medication.medication)
    end
  end

  def get_medication_name_from_codeable_concept(medication)
    medication_name = nil
    if medication.text.present?
      medication_name = medication.text
    elsif medication.coding.present?
      medication.coding.each do |coding|
        next unless coding.display

        medication_name = coding.display
        break
      end
    end
    medication_name
  end

  def get_medication_name_from_reference(medication)
    medication&.display
  end

  def get_medication_dates(medication)
    if medication.is_a? FhirServices::MedicationStatement
      get_medication_statement_dates(medication)
    else
      get_medication_order_dates(medication)
    end
  end

  def get_medication_order_dates(medication)
    dates = {
      start_date: nil,
      end_date: nil
    }

    if medication.dispense_request.validity_period.is_a? FhirServices::Period
      dates[:start_date] = medication.dispense_request.validity_period&.start
    elsif medication.date_written.is_a? Time
      dates[:start_date] = medication.date_written
    end

    dates[:end_date] = medication.date_ended if medication.date_ended.is_a? Time

    dates
  end

  def get_medication_statement_dates(medication)
    dates = {
      start_date: nil,
      end_date: nil
    }

    if medication.effective.is_a? FhirServices::Period
      dates[:start_date] = medication.effective&.start
      dates[:end_date] = medication.effective&.end
    elsif medication.effective.is_a? Time
      dates[:start_date] = medication.effective
    elsif medication.date_asserted.is_a? Time
      dates[:start_date] = medication.date_asserted
    end

    dates
  end

  def get_dosage_info(medication, fallback_dates)
    dosages = medication.is_a?(FhirServices::MedicationStatement) ? medication.dosage : medication.dosage_instruction
    extensions = medication.is_a?(FhirServices::MedicationStatement) ? medication.extension : nil
    return {} unless dosages.present?

    dosage = dosages.first

    quantity = dosage.try(:dose) || dosage.try(:quantity)

    {
      strength: "#{quantity.value.to_s.gsub(/(\.)0+$/, '')} #{quantity.unit}",
      quantity: "#{quantity.value.to_s.gsub(/(\.)0+$/, '')} #{quantity.unit}",
      frequency: dosage.timing.code.text,
      additional_instructions: dosage.try(:additional_instructions)&.text,
      category: get_category_from_extensions(extensions)
    }.merge!(get_dates_from_dosage(dosage, fallback_dates))
  end

  def get_dates_from_dosage(dosage, fallback_dates)
    if dosage.timing.repeat.bounds.is_a? FhirServices::Period
      get_dates_from_dosage_period(dosage.timing.repeat.bounds, fallback_dates)
    elsif dosage.timing.repeat.bounds.is_a? FhirServices::Quantity
      get_dates_from_dosage_quantity(dosage.timing.repeat.bounds, fallback_dates)
    end
  end

  def get_dates_from_dosage_period(period, fallback_dates)
    {
      start_date: period.start || fallback_dates[:start_date],
      end_date: period.end || fallback_dates[:end_date]
    }
  end

  def get_category_from_extensions(extensions)
    extensions&.map do |extension|
      extension.value.coding.find do |code|
        code.system == FHIR_CONFIG['medication_statement']['code_system']
      end.code
    end&.compact&.first
  end

  def get_dates_from_dosage_quantity(bounds_quantity, fallback_dates)
    dates = {
      start_date: nil,
      end_date: nil
    }

    return dates unless fallback_dates[:start_date]

    unit = TIMING_CODE_XREF.key?(bounds_quantity.code) ? TIMING_CODE_XREF[bounds_quantity.code] : bounds_quantity.unit
    duration = ChronicDuration.parse("#{bounds_quantity.value} #{unit}", keep_zero: true)
    dates[:start_date] = fallback_dates[:start_date]
    dates[:end_date] = fallback_dates[:start_date] + duration.seconds
    dates
  end

  def get_medication_order_references(medication)
    return unless medication.is_a? FhirServices::MedicationStatement

    medication.supporting_information
              .select { |info| info.reference.include? 'MedicationOrder/' }
              .map { |info| info.reference.split('/')[1] }
  end

  def valid_medication?(medication)
    valid_medication_start_date?(medication) &&
      valid_medication_end_date?(medication) &&
      valid_medication_name?(medication)
  end

  def valid_medication_start_date?(medication)
    medication[:start_date].blank? ||
      @date_range[:less_equal].blank? ||
      medication[:start_date] <= @date_range[:less_equal]
  end

  def valid_medication_end_date?(medication)
    medication[:end_date].blank? ||
      @date_range[:greater_equal].blank? ||
      medication[:end_date] >= @date_range[:greater_equal]
  end

  def valid_medication_name?(medication)
    medication[:medication].present?
  end

  def fetch_external_data(rxcui)
    Rails.cache.fetch("rxcui_#{rxcui}", expires_in: 1.day) { get_external_data(rxcui) }.tap do |result|
      Rails.cache.delete("rxcui_#{rxcui}") if result.nil?
    end
  end

  def get_external_data(rxcui)
    return nil if rxcui.empty?

    # get status
    rx_status = RxNav::RxNorm.status(rxcui)

    # check if remapped
    while rx_status.remapped? && rx_status.remapped_to.length == 1
      rxcui = rx_status.remapped_to.first
      rx_status = RxNav::RxNorm.status(rxcui)
    end

    # return if status is inacticve
    return nil unless rx_status.active?

    build_external_data(rxcui)
  rescue StandardError => e
    log_method_error(e, __method__.to_s)
    nil
  end

  def build_external_data(rxcui)
    external_data = initialize_external_data

    # get rxnav data
    get_rxnav_data(external_data, rxcui)

    # get ndfrt data
    get_ndfrt(external_data, rxcui)
  end

  def initialize_external_data
    {
      rxnorm: {
        related_tty_in: nil, # // related 'IN' term types (ingredients of the medication)
        available_strength: nil,
        strength: nil,
        quantity: nil
      },
      rxterms: {
        strength: nil
      },
      ndfrt: {
        strength: nil,
        units: nil
      }
    }
  end

  def get_rxnav_data(external_data, rxcui)
    threads = {}
    threads[:rxnorm_available_strength] = Thread.new { RxNav::RxNorm.available_strength(rxcui) }
    threads[:rxnorm_strength] = Thread.new { RxNav::RxNorm.strength(rxcui) }
    threads[:rxnorm_quantity] = Thread.new { RxNav::RxNorm.quantity(rxcui) }
    threads[:rxterm] = Thread.new { RxNav::RxTerms.all_info(rxcui) }
    threads[:rxnorm_related_tty_in] = Thread.new { RxNav::RxNorm.term_type_in(rxcui) }

    # get rxterms data
    rxterms = threads[:rxterm].value
    # get related_tty_in
    external_data[:rxnorm][:related_tty_in] = threads[:rxnorm_related_tty_in].value
    # get strength
    external_data[:rxterms][:strength] = rxterms[:strength]
    # get available_strength
    external_data[:rxnorm][:available_strength] = threads[:rxnorm_available_strength].value
    # get strength
    external_data[:rxnorm][:strength] = threads[:rxnorm_strength].value
    # get quantity
    external_data[:rxnorm][:quantity] = threads[:rxnorm_quantity].value
    external_data
  end

  def get_ndfrt(external_data, rxcui)
    threads = {}
    threads[:rxnorm_nui] = Thread.new { RxNav::RxNorm.nui(rxcui) }
    nui = threads[:rxnorm_nui].value
    return external_data if nui.nil?

    threads[:ndfrt_strength] = Thread.new { RxNav::NDFRT.get_strength(nui) }
    threads[:ndfrt_units] = Thread.new { RxNav::NDFRT.get_units(nui) }

    # get strength
    external_data[:ndfrt][:strength] = threads[:ndfrt_strength].value
    # get unit
    external_data[:ndfrt][:units] = threads[:ndfrt_units].value
    external_data
  end

  def normalize_medication_name(external_data, medication)
    return medication[:medication] if external_data.nil?

    temp_name = medication[:medication]

    unless external_data[:rxnorm][:related_tty_in].empty?
      temp_name = external_data[:rxnorm][:related_tty_in].sort.join('-')
    end
    temp_name
  end

  def normalize_medication_dose_strength(external_data, medication)
    return medication[:strength] if external_data.nil?

    temp_strength = medication[:strength]
    external_strength = get_ndfrt_strength(external_data)
    temp_strength = external_strength if external_strength

    temp_strength
  end

  def get_ndfrt_strength(external_data)
    temp_strength = if external_data[:ndfrt][:strength] && external_data[:ndfrt][:units]
                      "#{external_data[:ndfrt][:strength]} #{external_data[:ndfrt][:units]}"
                    else # else get_rxnorm_strength
                      get_rxnorm_strength(external_data)
                    end
    temp_strength
  end

  def get_rxnorm_strength(external_data)
    # if external_data[:rxnorm][:available_strength]
    temp_strength = if external_data[:rxnorm][:available_strength]
                      external_data[:rxnorm][:available_strength]
                      # else if external_data
                    elsif external_data[:rxnorm][:strength]
                      external_data[:rxnorm][:strength]
                      # else get_rxterms_strength
                    else
                      get_rxterms_strength(external_data)
                    end
    temp_strength
  end

  def get_rxterms_strength(external_data)
    external_data[:rxterms][:strength]
  end

  def normalize_medication_dose_quantity(external_data, medication)
    medication[:quantity] || external_data.nil? ? medication[:quantity] : external_data[:rxnorm][:quantity]
  end

  def normalize_with_external_data(external_data, medication)
    # normalize name
    medication[:medication] = normalize_medication_name(external_data, medication)

    # normalize strength
    medication[:strength] = normalize_medication_dose_strength(external_data, medication)

    # normalize quanity
    medication[:quanity] = normalize_medication_dose_quantity(external_data, medication)
  end

  def apply_external_data(medications)
    threads = {}

    # start thread to get external data for each rxcui value
    medications.each do |entry|
      next if entry[:rxcui].blank? || threads.key?(entry[:rxcui])

      threads[entry[:rxcui]] = Thread.new { fetch_external_data(entry[:rxcui]) }
    end

    # apply external data to each entry
    medications.each do |entry|
      next if entry[:rxcui].blank?

      normalize_with_external_data(threads[entry[:rxcui]].value, entry)
    end
  end
end
