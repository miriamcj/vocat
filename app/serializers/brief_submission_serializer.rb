class BriefSubmissionSerializer < AbstractSubmissionSerializer
  attributes  :id,
              :creator_id,
              :project_id,
              :creator_type,
              :serialized_state,
              :current_user_published?,
              :current_user_percentage,
              :instructor_score_percentage,
              :role,
              :has_asset?,
              :list_name

  def list_name
    object.creator.list_name
  end

  def serialized_state
	  'partial'
  end

end
