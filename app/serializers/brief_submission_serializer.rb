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
              :list_name,
              :discussion_posts_count,
              :user_left_feedback?

  def list_name
    object.creator.list_name
  end

  def serialized_state
    'partial'
  end

  def user_left_feedback?
    object.user_left_feedback?(scope)
  end

  def discussion_posts_count
    if object.discussion_posts_count > 0
      return object.discussion_posts_count
    else
      nil
    end
  end

end
