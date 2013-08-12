FactoryGirl.define do
	factory :submission do
		association :creator, factory: :creator, strategy: :build
		association :project, factory: :project, strategy: :build
	end
end
