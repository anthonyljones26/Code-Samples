FactoryBot.define do
  factory :reference, class: FhirServices::Reference do
    reference { 'abc123' }
    display { 'some reference' }

    trait :support_info do
      reference { 'MedicationOrder/23945971' }
    end
  end
end
