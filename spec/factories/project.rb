FactoryGirl.define do
  factory :project do
    type 'User'
    association :course, factory: :course
    association :rubric, factory: :rubric
    name "Test Project"
    description "Qui quia fuga quo. Soluta ratione quis deleniti. Fu..."
  end
end
