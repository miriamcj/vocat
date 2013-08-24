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
              :current_user_evaluation_published?,
              :current_user_evaluation,
              :discussion_posts_count,
              :course_id, :path,
              :course_name,
              :course_section,
              :course_number,
              :course_name_long,
              :project_name,
              :project_id,
              :serialized_state


  def serialized_state
	  'partial'
  end

end
