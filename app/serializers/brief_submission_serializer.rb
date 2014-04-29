class BriefSubmissionSerializer < AbstractSubmissionSerializer
  attributes  :id,
              :thumb,
              :creator_name,
              :creator_id,
              :creator_type,
              :instructor_score_percentage,
              :published,
              :has_video?,
              :evaluated_by_instructor?,
              :current_user_percentage,
              :current_user_has_evaluated?,
              :current_user_evaluation,
              :current_user_evaluation_published?,
              :discussion_posts_count,
              :course_id, :path,
              :project_id,
              :serialized_state


  def evaluated_by_instructor?
    if scope.role?(:administrator) || scope.role?(:evaluator)
      object.evaluated_by_instructor?
    else
      false
    end
  end

  def instructor_score_percentage
    if scope.role?(:administrator) || scope.role?(:evaluator)
      object.instructor_score_percentage
    else
      0
    end
  end

  def serialized_state
	  'partial'
  end

end
