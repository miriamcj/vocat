# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :semester do
    name "Fall 2015"
    position 1
    start_date "2017-05-13"
    end_date "2017-09-23"
    association :organization, factory: :organization
  end
end
