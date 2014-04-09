FactoryGirl.define do
  factory :rubric do
    name 'A test rubric'
    low 0
    high 10
    association :owner, factory: :evaluator, strategy: :build
    fields []
    cells []
    ranges []
  end
end
