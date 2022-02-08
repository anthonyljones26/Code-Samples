FactoryBot.define do
  factory :period, class: FhirServices::Period do
    start { 1.days.ago }
  end
end
