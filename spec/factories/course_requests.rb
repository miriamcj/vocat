# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :course_request do
    name "MyString"
    department "MyString"
    section "MyString"
    year 1
    semester 1
    requestor_id 1
    state 1
    admin_id 1
    course_id 1
  end
end
