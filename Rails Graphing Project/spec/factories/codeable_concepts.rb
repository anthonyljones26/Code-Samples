FactoryBot.define do
  factory :codeable_concept, class: FhirServices::CodeableConcept do
    coding { [:code] }
    text { 'code text' }

    factory :medication do
      coding do
        [
          FactoryBot.build(
            :code,
            system: 'http://www.nlm.nih.gov/research/umls/rxnorm',
            code: '',
            display: 'Sectral'
          )
        ]
      end
      sequence(:text, 1) { |n| "medication#{n}" }

      trait :rxcui do
        coding do
          [
            FactoryBot.build(
              :code,
              system: 'http://www.nlm.nih.gov/research/umls/rxnorm',
              code: '855302',
              display: 'Medication D'
            )
          ]
        end
      end
    end

    factory :timing_QD do
      coding do
        [FactoryBot.build(:code, system: 'http://hl7.org/fhir/timing-abbreviation', code: 'QD', display: 'QD')]
      end
      text { 'Daily' }
    end

    factory :timing_Q4H do
      coding do
        [FactoryBot.build(:code, system: 'http://hl7.org/fhir/timing-abbreviation', code: 'Q4H', display: 'Q4H')]
      end
      text { 'q4hr' }
    end

    factory :timing_BID do
      coding do
        [FactoryBot.build(:code, system: 'http://hl7.org/fhir/timing-abbreviation', code: 'BID', display: 'BID')]
      end
      text { 'BID' }
    end

    factory :route_INH do
      coding do
        [
          FactoryBot.build(
            :code,
            system: 'http://snomed.info/sct',
            code: '447694001',
            display: 'Respiratory tract route (qualifier value)'
          )
        ]
      end
      text { 'INH' }
    end

    factory :route_oral do
      coding do
        [
          FactoryBot.build(
            :code,
            system: 'http://snomed.info/sct',
            code: '26643006',
            display: 'Oral route (qualifier value)'
          )
        ]
      end
      text { 'Oral' }
    end

    factory :inpatient do
      coding do
        [
          FactoryBot.build(
            :code,
            system: 'http://hl7.org/fhir/medication-statement-category',
            code: 'inpatient',
            display: 'Inpatient'
          )
        ]
      end
      text { 'Inpatient' }
    end

    factory :outpatient do
      coding do
        [
          FactoryBot.build(
            :code,
            system: 'http://hl7.org/fhir/medication-statement-category',
            code: 'outpatient',
            display: 'Outpatient'
          )
        ]
      end
      text { 'Outpatient' }
    end

    factory :home_med do
      coding do
        [
          FactoryBot.build(
            :code,
            system: 'http://hl7.org/fhir/medication-statement-category',
            code: 'patientspecified',
            display: 'Patient Specified'
          )
        ]
      end
      text { 'Patient Specified' }
    end
    factory :additional_info do
      coding { [:code] }
      text { 'Testing additional information, thank you for reading this' }
    end
  end
end
