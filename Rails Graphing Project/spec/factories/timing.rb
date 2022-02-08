FactoryBot.define do
  factory :timing, class: FhirServices::Timing do
    transient do
      start_date { 1.years.ago }
      end_date { DateTime.now }
    end
    repeat { FactoryBot.build(:repeat, start_date: start_date, end_date: end_date) }
    code { FactoryBot.build(:codeable_concept) }

    trait :blank do
      code { FactoryBot.build(:codeable_concept, text: '--') }
    end
  end

  factory :repeat, class: FhirServices::Timing::Repeat do
    transient do
      start_date { 1.years.ago }
      end_date { DateTime.now }
    end
    bounds { FactoryBot.build(:period, start: start_date, end: end_date) }
    count { 4 }
  end
end
