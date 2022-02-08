FactoryBot.define do
  factory :medication_order, class: FhirServices::MedicationOrder do
    transient do
      name { 'Medication' }
      dose_strength { 1 }
      dose_text { 'Testing dosage text' }
      start_date { 1.years.ago }
      end_date { DateTime.now }
    end

    sequence(:id) { |n| n + 1000 }
    meta { FactoryBot.build(:meta) }
    status { 'active' }
    sequence(:date_written, 90) { |n| n.days.ago }
    medication { FactoryBot.build(:medication, text: name) }
    dosage_instruction do
      [
        FactoryBot.build(
          :dosage_instruction,
          dose_strength: dose_strength,
          dose_text: dose_text,
          start_date: start_date,
          end_date: end_date
        )
      ]
    end
    dispense_request { FactoryBot.build(:dispense_request, start_date: start_date, end_date: end_date) }

    trait :partial do
      dosage_instruction do
        [
          FactoryBot.build(
            :dosage_instruction,
            text: '--',
            additional_instructions: FactoryBot.build(:codeable_concept, text: '--'),
            timing: FactoryBot.build(:timing, :blank, start_date: nil, end_date: nil),
            route: nil,
            dose: FactoryBot.build(:quantity, :blank, value: '--')
          )
        ]
      end

      dispense_request { FactoryBot.build(:dispense_request, start_date: nil, end_date: nil) }
    end
  end

  factory :dosage_instruction, class: FhirServices::MedicationOrder::DosageInstruction do
    transient do
      dose_strength { 1 }
      dose_text { 'Testing dosage text' }
      start_date { 1.years.ago }
      end_date { DateTime.now }
    end
    text { dose_text }
    additional_instructions { FactoryBot.build(:additional_info) }
    timing { FactoryBot.build(:timing, start_date: start_date, end_date: end_date) }
    route { FactoryBot.build(:route_oral) }
    dose { FactoryBot.build(:quantity, :tablet, value: dose_strength) }
    rate { FactoryBot.build(:range) }
  end

  factory :dispense_request, class: FhirServices::MedicationOrder::DispenseRequest do
    transient do
      start_date { 1.years.ago }
      end_date { DateTime.now }
    end
    validity_period { FactoryBot.build(:period, start: start_date, end: end_date) }
  end
end
