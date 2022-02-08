FactoryBot.define do
  factory :meta, class: FhirServices::Meta do
    version_id { '123456' }
    last_updated { Time.now }
  end
end
