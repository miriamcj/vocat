# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :semester do
    name "Fall 2015"
    position 1
    association :organization, factory: :organization
  end
end
