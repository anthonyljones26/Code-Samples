FactoryBot.define do
  factory :observation, class: FhirServices::Observation do
    transient do
      days_ago { 1 }
      source { 'other' }
      sbp { 100.0 }
      dbp { 60.0 }
      exact_date { '2013-03-10T16:00:00.000Z' }
    end

    id { '12345' }
    meta { FactoryBot.build(:meta) }
    status { 'active' }
    category do
      FactoryBot.build(
        :codeable_concept,
        coding: [FactoryBot.build(
          :code, system: 'http://hl7.org/fhir/observation-category', code: 'vital-signs', display: 'Vital Signs'
        )],
        text: 'Vital Signs'
      )
    end
    code do
      FactoryBot.build(
        :codeable_concept,
        coding: [
          FactoryBot.build(
            :code, system: 'http://snomed.info/sct', code: '75367002', display: 'Blood pressure (observable entity)'
          ),
          FactoryBot.build(:code, system: 'http://loinc.org', code: '55284-4', display: '')
        ],
        text: 'Blood pressure'
      )
    end
    subject { :reference }
    encounter { :reference }
    effective_datetime { days_ago.days.ago }
    issued { days_ago.days.ago }
    value_quantity { FactoryBot.build(:quantity) }
    interpretation { :codeable_concept }
    reference_range { [FactoryBot.build(:range)] }
    component do
      data = []
      data.push(FactoryBot.build(:component, :systolic, source: source, bp_value: sbp)) if sbp
      data.push(FactoryBot.build(:component, :diastolic, source: source, bp_value: dbp)) if dbp
      data
    end

    trait :use_date do
      effective_datetime { exact_date }
      issued { exact_date }
    end
  end

  factory :component, class: FhirServices::Observation::Component do
    transient do
      bp_value { 1 }
      source { 'other' }
    end
    code do
      FactoryBot.build(
        :codeable_concept,
        coding: [
          FactoryBot.build(
            :code, system: 'http://loinc.org', code: '8459-0', display: 'Blood pressure (observable entity)'
          ),
          FactoryBot.build(:code, system: 'http://loinc.org', code: '8480-6', display: '')
        ],
        text: 'other'
      )
    end
    value_quantity do
      FactoryBot.build(
        :quantity, value: bp_value, unit: 'mmHg', system: 'http://unitsofmeasure.org', code: 'mm[Hg]'
      )
    end
    reference_range do
      [FactoryBot.build(
        :range,
        low: FactoryBot.build(
          :quantity, value: 75.0, unit: 'mmHg', system: 'http://unitsofmeasure.org', code: 'mm[Hg]'
        ),
        high: FactoryBot.build(
          :quantity, value: 125.0, unit: 'mmHg', system: 'http://unitsofmeasure.org', code: 'mm[Hg]'
        )
      )]
    end

    trait :systolic do
      code do
        FactoryBot.build(
          :codeable_concept,
          coding: [
            FactoryBot.build(
              :code, system: 'http://loinc.org', code: '8459-0', display: 'Blood pressure (observable entity)'
            ),
            FactoryBot.build(:code, system: 'http://loinc.org', code: '8480-6', display: '')
          ],
          text: source
        )
      end

      reference_range do
        [FactoryBot.build(
          :range,
          low: FactoryBot.build(
            :quantity, value: 90.0, unit: 'mmHg', system: 'http://unitsofmeasure.org', code: 'mm[Hg]'
          ),
          high: FactoryBot.build(
            :quantity, value: 139.0, unit: 'mmHg', system: 'http://unitsofmeasure.org', code: 'mm[Hg]'
          )
        )]
      end
    end

    trait :diastolic do
      code do
        FactoryBot.build(
          :codeable_concept,
          coding: [
            FactoryBot.build(
              :code, system: 'http://loinc.org', code: '8459-0', display: 'Blood pressure (observable entity)'
            ),
            FactoryBot.build(:code, system: 'http://loinc.org', code: '8462-4', display: '')
          ],
          text: source
        )
      end

      reference_range do
        [FactoryBot.build(
          :range,
          low: FactoryBot.build(
            :quantity, value: 60.0, unit: 'mmHg', system: 'http://unitsofmeasure.org', code: 'mm[Hg]'
          ),
          high: FactoryBot.build(
            :quantity, value: 90.0, unit: 'mmHg', system: 'http://unitsofmeasure.org', code: 'mm[Hg]'
          )
        )]
      end
    end
  end
end
