class BriefSubmissionSerializer < AbstractSubmissionSerializer
  attributes  :id,
              :creator_id,
              :project_id,
              :creator_type,
              :serialized_state,
              :current_user_published?,
              :current_user_percentage


  def serialized_state
	  'partial'
  end

end
