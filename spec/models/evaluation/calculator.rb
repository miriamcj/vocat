require '../../spec_helper'

describe Evaluation::Calculator do

  context 'when performing calculations on a collection of evaluations' do

    before :all do
      @submission = FactoryGirl.create(:submission)
      params = [
          {:score => 1, evaluator: FactoryGirl.create(:creator)},
          {:score => 2, evaluator: FactoryGirl.create(:creator)},
          {:score => 5, evaluator: FactoryGirl.create(:evaluator)},
          {:score => 5, evaluator: FactoryGirl.create(:evaluator)}
      ]
      @evaluations = []
      params.each do |param|
        e = FactoryGirl.create(:evaluation, :scores => {:a_criteria => param[:score]}, :evaluator => param[:evaluator], :submission => @submission, )
        @evaluations << e
      end
    end

    it 'correctly calculates average percentage for all evaluations of a given submission' do
      percentages = @evaluations.map { |e| e.total_percentage}
      avg = percentages.inject{ |sum, el| sum + el }.to_f / percentages.size
      expect(Evaluation::Calculator.average_percentage_for_submission(@submission)).to eq(avg)
    end

    it 'correctly calculates average percentage for evaluator evaluations of a given submission' do
      type = Evaluation::EVALUATION_TYPE_EVALUATOR
      percentages = @evaluations.select { |e| e.evaluation_type == type }.map { |e| e.total_percentage}
      avg = percentages.inject{ |sum, el| sum + el }.to_f / percentages.size
      expect(Evaluation::Calculator.average_percentage_for_submission(@submission, type)).to eq(avg)
    end

    it 'correctly calculates average percentage for creator evaluations of a given submission' do
      type = Evaluation::EVALUATION_TYPE_CREATOR
      percentages = @evaluations.select { |e| e.evaluation_type == type }.map { |e| e.total_percentage}
      avg = percentages.inject{ |sum, el| sum + el }.to_f / percentages.size
      expect(Evaluation::Calculator.average_percentage_for_submission(@submission, type)).to eq(avg)
    end


  end


end
