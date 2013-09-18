class SubmissionSerializer < AbstractSubmissionSerializer

  attributes  :id, :name, :thumb, :course_name, :course_name_long, :course_allows_peer_review, :course_allows_self_evaluation,
              :project_name, :course_id, :project_id, :creator_name, :creator_id, :creator_type, :current_user_is_owner,
              :current_user_can_evaluate, :course_department, :course_section, :course_number,
              :evaluations, :current_user_percentage, :current_user_evaluation_published?, :current_user_has_evaluated?,
              :current_user_can_annotate, :current_user_can_attach, :current_user_can_discuss, :video,
              :has_video?, :path, :peer_score_percentage, :instructor_score_percentage, :current_user_is_instructor, :discussion_posts_count,
              :serialized_state

  # This makes sure that the correct serializer is used for the child association.
  has_one :video
#	has_many :evaluations

	def serialized_state
		'full'
	end

end
