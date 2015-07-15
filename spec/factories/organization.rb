FactoryGirl.define do
  factory :organization do
    name "Organization"
    active true
    sequence :subdomain do |n|
      "org#{Time.now.to_i}#{n}"
    end

  end
end
