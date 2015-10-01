FactoryGirl.define do
  factory :organization do
    name "Organization"
    active true
    email_default_from "rambo@castironcoding.com"
    sequence :subdomain do |n|
      "org#{Time.now.to_i}#{n}"
    end

  end
end
