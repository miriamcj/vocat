FactoryGirl.define do
  factory :video do
    source 'youtube'
    source_id 'ND1X594F1wY'
    association :submission, factory: :submission
  end
end
