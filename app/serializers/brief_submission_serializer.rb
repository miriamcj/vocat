class BriefSubmissionSerializer < ActiveModel::Serializer
  attributes  :id, :thumb, :creator_id, :project_id, :instructor_score_percentage, :published, :has_video?,
              :evaluated_by_instructor?, :current_user_percentage, :current_user_has_evaluated?, :current_user_evaluation_published?,
              :current_user_evaluation, :discussion_posts_count

  def current_user_percentage
    object.user_score_percentage(scope)
  end

  def current_user_has_evaluated?
    object.evaluated_by_user?(scope)
  end

  def current_user_evaluation_published?
    object.user_evaluation_published?(scope)
  end

  def current_user_evaluation
    object.user_evaluation(scope)
  end


end
