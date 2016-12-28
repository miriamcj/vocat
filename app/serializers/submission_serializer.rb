# == Schema Information
#
# Table name: submissions
#
#  id                     :integer          not null, primary key
#  name                   :string
#  summary                :text
#  project_id             :integer
#  creator_id             :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  published              :boolean
#  discussion_posts_count :integer          default(0)
#  creator_type           :string           default("User")
#  assets_count           :integer          default(0)
#
# Indexes
#
#  index_submissions_on_creator_id  (creator_id)
#  index_submissions_on_project_id  (project_id)
#

class SubmissionSerializer < AbstractSubmissionSerializer

  attributes :id,
             :name,
             :path,
             :serialized_state,
             :path,
             :role,
             :discussion_posts_count,
             :new_posts_for_current_user?,
             :project,
             :creator,
             :creator_id,
             :creator_type,
             :project_id,
             :evaluations,
             :abilities,
             :current_user_published?,
             :current_user_percentage,
             :evaluated_by_peers?,
             :peer_score_percentage,
             :evaluated_by_instructor?,
             :instructor_score_percentage,
             :has_asset?,
             :annotations_count

  has_one :project
  has_one :creator
  has_many :assets

  protected

  def serialized_state
    'full'
  end

end
