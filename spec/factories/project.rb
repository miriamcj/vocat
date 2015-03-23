FactoryGirl.define do
  factory :project do
    type 'UserProject'
    association :course, factory: :course
    association :rubric, factory: :rubric
    name "Test Project"
    description "Qui quia fuga quo. Soluta ratione quis deleniti. Fu..."
  end
end
