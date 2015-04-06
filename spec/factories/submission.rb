FactoryGirl.define do
	factory :submission do
    name 'a test submission'
    published true
    creator_type 'User'
    association :project, factory: :user_project
    association :creator, factory: :creator

    factory :group_submission do
      name 'a test group submission'
      creator_type 'Group'
      association :creator, factory: :group
    end
	end
end