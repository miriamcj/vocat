FactoryGirl.define do
  factory :rubric do
    name 'A test rubric'
    association :owner, factory: :evaluator, strategy: :build
    fields []
    cells []
    ranges []
  end
end
