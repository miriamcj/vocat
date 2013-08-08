FactoryGirl.define do
  factory :user do
    first_name 'John'
    last_name  'Doe'
    password 'password'
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
