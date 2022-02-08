FactoryBot.define do
  factory :code, class: FhirServices::Code do
    system { 'code system' }
    code { '123456' }
    display { 'some code' }
  end
end
