FactoryGirl.define do
	factory :submission do
    name 'a test submission'
    published true
    association :project, factory: :project
    association :creator, factory: :creator
	end
end
