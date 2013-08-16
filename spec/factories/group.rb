FactoryGirl.define do
  factory :group do
    association :course, factory: :course
    name "Test Group"
  end
end
