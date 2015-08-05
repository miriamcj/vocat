class SubmissionStatisticsSerializer < AbstractSubmissionSerializer

  attributes :id,
             :name,
             :path,
             :serialized_state,
             :discussion_posts_count,
             :creator,
             :creator_id,
             :creator_type,
             :project_id,
             :current_user_published?,
             :current_user_percentage,
             :peer_score_percentage,
             :instructor_score_percentage,
             :has_asset?

  has_one :creator
  has_many :assets

  protected

  def serialized_state
    'full'
  end

end
