class Reporter::Project

  include Reporter

  def initialize (project, format)
      @project = project
      @format = format
      @course = @project.course
      @members = @course.users.pluck(:id, :last_name, :first_name).map { |m| [m[0], "#{m[1]}, #{m[2]}"] }.to_h
      @rubric = @project.rubric
      @points_possible = @rubric.points_possible
      @fields = @rubric.fields.map { |field| [field[:id], field[:name]]}.to_h
  end

  def peer_scores()
    evaluations = Evaluation.joins(:submission => :project).where('projects.id = ? AND evaluator_id IN (?)', @project.id, @course.creators.pluck(:id)).select(
        'scores', 'evaluator_id', 'submission_id', 'submissions.creator_id', 'submissions.creator_type')
    evaluations_report(evaluations, true, false)
  end

  def evaluator_scores()
    evaluations = Evaluation.joins(:submission => :project).where('projects.id = ? AND evaluator_id IN (?)', @project.id, @course.evaluators.pluck(:id)).select(
        'scores', 'evaluator_id', 'submission_id', 'submissions.creator_id', 'submissions.creator_type')
    evaluations_report(evaluations, false, false)
  end

  def all_scores()
    evaluations = Evaluation.joins(:submission => :project).where('projects.id = ?', @project.id).select(
        'scores', 'evaluator_id', 'submission_id', 'submissions.creator_id', 'submissions.creator_type')
    evaluations_report(evaluations, false, false)
  end

  def self_scores()
    evaluations = Evaluation.joins(:submission => :project).where('projects.id = ? AND evaluator_id IN (?)', @project.id, @course.creators.pluck(:id)).select(
        'scores', 'evaluator_id', 'submission_id', 'submissions.creator_id', 'submissions.creator_type')
    evaluations_report(evaluations, false, true)
  end

  protected

  def evaluations_report(evaluations, exclude_self = true, only_self = false)
    report = new_report
    field_headers = @fields.values.map { |s| s.gsub(/[^0-9a-z ]/i, '').truncate(25) }
    report.headers = ['Creator Name', 'Evaluator Name'] + field_headers + ['Total Score', 'Total Percentage', 'Average Score']

    evaluations.each do |evaluation|
      out = []
      cid = evaluation[:creator_id]
      eid = evaluation[:evaluator_id]
      next if cid == eid && exclude_self == true
      next if cid != eid && only_self == true

      scores = evaluation[:scores].values.map { |s| s.to_f}

      # 1. Creator Name
      if evaluation[:creator_type] == 'Group'
        group = Group.find cid
        group_member_ids = group.creators.pluck(:id)
        next if group_member_ids.include?(eid) && exclude_self == true
        next if !group_member_ids.include?(eid) && only_self == true
        out.push group.name
      elsif evaluation[:creator_type] == 'Creator'
        out.push "#{@members[cid][:last_name]}, #{@members[cid][:first_name]}"
      else
        out.push ""
      end

      # 2. Evaluator Name
      out.push @members[eid].nil? ? User.find(eid).list_name : @members[eid]

      # 3. Rubric Fields
      @fields.keys.each do |field_key|
        out.push evaluation[:scores][field_key]
      end

      # 4. Total
      out.push scores.sum

      # 5. Percentage
      out.push scores.sum / @points_possible

      # 6. Average
      out.push scores.reduce(:+).to_f / scores.size

      if @format == 'json'
        out = Hash[report.headers.zip(out)]
      end
      report.rows << out
    end
    report
  end

end