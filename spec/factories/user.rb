FactoryGirl.define do
  factory :user do
    first_name 'John'
    last_name  'Doe'
    password 'password'
    association :organization, factory: :organization
    role 'creator'
    sequence :email do |n|
      "person#{Time.now.to_i}#{n}@example.com"
    end

  end

  factory :creator, parent: :user do
    role 'creator'
  end

  factory :evaluator, parent: :user do
    role 'evaluator'
  end

  factory :administrator, parent: :user do
    role 'administrator'
  end

  factory :superadministrator, parent: :user do
    role 'superadministrator'
    organization nil
  end

  factory :assistant, parent: :user do
    role 'assistant'
  end

end
