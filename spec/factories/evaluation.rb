FactoryGirl.define do
  factory :evaluation do
    published true
    association :submission, factory: :submission
    association :evaluator, factory: :user
    association :rubric, factory: :rubric
  end
end