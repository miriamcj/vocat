require 'spec_helper'

describe CourseRequest do

  let(:cr) { FactoryGirl.build(:course_request) }

  it 'has a valid factory' do
    expect(cr).to be_valid
  end

  it 'triggers the deny callback when state changes to denied' do
    expect(cr).to receive(:handle_denied)
    cr.deny
  end

  it 'triggers the approve callback when state changes to approved' do
    expect(cr).to receive(:handle_approved)
    cr.approve
  end

  it 'triggers notification the first time it is saved' do
    expect_any_instance_of(CourseRequest).to receive(:notify)
    cr
    cr.save
  end

  it 'does not trigger notification the second time it is saved' do
    cr
    cr.save
    expect_any_instance_of(CourseRequest).to_not receive(:notify)
    cr.name = "John Rambo II"
    cr.save
  end


end

