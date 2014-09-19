class Evaluation::Calculator

  def self.averages(evaluations)
    {
        average_score: self.avg_score(evaluations),
        average_percentage: avg_percentage(evaluations),
        count: evaluations.count
    }
  end

  def self.avg_percentage(evaluations)
    evaluations.average('total_percentage') || 0
  end

  def self.avg_score(evaluations)
    evaluations.average('total_score') || 0
  end

  def self.average_percentage_for_submission(submission, type = nil)
    set = submission.evaluations
    if !type.nil?
      set = set.where(:evaluation_type => type)
    end
    set.average(:total_percentage)
  end

end