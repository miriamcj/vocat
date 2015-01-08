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

  context 'when converting to a course' do

    before(:all) do
      @cr = FactoryGirl.build(:course_request)
      @course = @cr.to_course
    end

    it 'the resulting course has the same evaluator as the course request' do
      expect(@course.evaluators.includes(@cr.evaluator)).to be true
    end

    it 'the resulting  course has the same name as the course request' do
      expect(@course.name).to eq(@cr.name)
    end

    it 'the resulting course has the same number as the course request' do
      expect(@course.number).to eq(@cr.number)
    end

    it 'the resulting course has the same year as the course request' do
      expect(@course.year).to eq(@cr.year)
    end

    it 'the resulting course has the same department as the course request' do
      expect(@course.department).to eq(@cr.department)
    end

    it 'the resulting course has the same semester as the course request' do
      expect(@course.semester).to eq(@cr.semester)
    end

    it 'the resulting course has the same section as the course request' do
      expect(@course.section).to eq(@cr.section)
    end

  end

end

