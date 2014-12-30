require 'spec_helper'

describe 'Course' do

  it 'has a valid factory' do
    FactoryGirl.build(:course).should be_valid
  end

  it "enrolls an evaluator with the correct role" do
    course = FactoryGirl.create(:course)
    evaluator = FactoryGirl.build(:evaluator)
    course.enroll(evaluator)
    expect(course.role(evaluator)).to be(:evaluator)
  end

  it "enrolls a creator with the correct role" do
    course = FactoryGirl.create(:course)
    creator = FactoryGirl.build(:creator)
    course.enroll(creator)
    expect(course.role(creator)).to be(:creator)
  end

  it "enrolls an assistant with the correct role" do
    course = FactoryGirl.create(:course)
    assistant = FactoryGirl.build(:assistant)
    course.enroll(assistant)
    expect(course.role(assistant)).to be(:assistant)
  end

end
