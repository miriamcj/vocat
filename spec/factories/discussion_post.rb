FactoryGirl.define do
  factory :discussion_post do
    body 'a test discussion post'
    published true
    association :author, factory: :creator
    association :submission, factory: :submission
  end
end
