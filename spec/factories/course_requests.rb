# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :course_request do
    name "Rambo 101: John Rambo"
    department "RAM"
    number "101"
    section "1234"
    year 2014
    association :semester, factory: :semester
    association :evaluator, factory: :evaluator
    state :pending
  end
end
