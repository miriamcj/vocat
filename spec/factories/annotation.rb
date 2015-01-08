FactoryGirl.define do
  factory :annotation do
    body 'a test annotation'
    seconds_timecode '00:00:00'
    association :author, factory: :creator
    association :asset, factory: :asset
  end
end
