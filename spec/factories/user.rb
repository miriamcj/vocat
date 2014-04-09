FactoryGirl.define do
  factory :user do
    first_name 'John'
    last_name  'Doe'
    password 'password'
    role 'creator'
    sequence :email do |n|
      "person#{n}@example.com"
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

end
