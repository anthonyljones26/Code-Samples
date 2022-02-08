FactoryBot.define do
  factory :range, class: FhirServices::Range do
    low { FactoryBot.build(:quantity) }
    high { FactoryBot.build(:quantity) }
  end
end
