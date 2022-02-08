FactoryBot.define do
  factory :quantity, class: FhirServices::Quantity do
    value { -1.0 }
    unit { 'grams' }
    system { 'system' }
    code { '123' }

    trait :mg do
      value { 120 }
      unit { 'mg' }
      system { 'http://unitsofmeasure.org' }
      code { 'mg' }
    end

    trait :puffs do
      value { 2 }
      unit { 'puff(s)' }
      system { 'http://unitsofmeasure.org' }
      code { '{Puff}' }
    end

    trait :tablet do
      value { 1 }
      unit { 'tab(s)' }
      system { 'http://unitsofmeasure.org' }
      code { '{tbl}' }
    end

    trait :blank do
      value { nil }
      unit { nil }
      system { 'http://unitsofmeasure.org' }
      code { '--' }
    end
  end
end
