FactoryGirl.define do
  factory :project do
    association :course, factory: :course
    name "Test Project"
    description "Qui quia fuga quo. Soluta ratione quis deleniti. Fu..."
  end
end
