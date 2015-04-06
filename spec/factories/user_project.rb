FactoryGirl.define do
  factory :user_project do
    association :course, factory: :course
    association :rubric, factory: :rubric
    name "Test User Project"
    description "Qui quia fuga quo. Soluta ratione quis deleniti. Fu..."
  end
end
