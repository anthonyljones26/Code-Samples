FactoryBot.define do
  factory :medication_statement, class: FhirServices::MedicationStatement do
    transient do
      name { 'Medication' }
      dose_strength { 1 }
      dose_text { 'Testing dosage text' }
      start_date { 1.years.ago }
      end_date { DateTime.now }
      not_taken { false }
      order_id { 0 }
    end

    sequence(:id) { |n| n + 2000 }
    meta { FactoryBot.build(:meta) }
    status { 'active' }
    sequence(:date_asserted, 90) { |n| n.days.ago }
    effective { FactoryBot.build(:period, start: start_date, end: end_date) }
    was_not_taken { not_taken }
    reason_for_use { FactoryBot.build(:codeable_concept) }
    supporting_information { [FactoryBot.build(:reference, reference: "MedicationOrder/#{order_id}")] }
    medication { FactoryBot.build(:medication, text: name) }
    dosage do
      [
        FactoryBot.build(
          :dosage,
          dose_text: dose_text,
          dose_strength: dose_strength,
          start_date: start_date,
          end_date: end_date
        )
      ]
    end
    extension { [FactoryBot.build(:extension)] }

    trait :home_med do
      extension do
        [
          FactoryBot.build(
            :extension,
            value: FactoryBot.build(:home_med)
          )
        ]
      end
    end

    trait :outpatient do
      extension do
        [
          FactoryBot.build(
            :extension,
            value: FactoryBot.build(:outpatient)
          )
        ]
      end
    end

    trait :rxcui do
      medication { FactoryBot.build(:medication, :rxcui, text: name) }
    end
  end

  factory :dosage, class: FhirServices::MedicationStatement::Dosage do
    transient do
      dose_strength { 1 }
      dose_text { 'Testing dosage text' }
      start_date { 1.years.ago }
      end_date { DateTime.now }
    end
    text { dose_text }
    timing { FactoryBot.build(:timing, start_date: start_date, end_date: end_date) }
    route { FactoryBot.build(:route_oral) }
    quantity { FactoryBot.build(:quantity, :tablet, value: dose_strength) }
    rate { FactoryBot.build(:range) }
  end

  factory :extension, class: FhirServices::MedicationStatement::Extension do
    url { 'https://fhir-ehr.cerrner.com/dstu2/StructureDefinition/medication-statement-category' }
    value { FactoryBot.build(:inpatient) }
  end
end
