FactoryGirl.define do
  factory :course do
    name "Test Course"
    department "CS"
    number "163"
    section "AI7X4"
    description "Qui quia fuga quo. Soluta ratione quis deleniti. Fu..."
    association :organization, factory: :organization
  end
end
