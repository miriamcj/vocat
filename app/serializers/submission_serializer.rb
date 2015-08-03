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
             :has_asset?

  has_one :project
  has_one :creator
  has_many :assets

  protected

  def new_posts_for_current_user?
    object.new_posts_for_user?(scope)
  end

  def abilities
    ability = Ability.new(scope)
    {
        can_own: ability.can?(:own, object),
        can_evaluate: ability.can?(:evaluate, object),
        can_attach: ability.can?(:attach, object),
        can_discuss: ability.can?(:discuss, object),
        can_annotate: ability.can?(:annotate, object),
        can_administer: ability.can?(:administer, object)
    }
  end

  # We scope the visible evaluations to the user
  def evaluations
    evaluations = object.evaluations_visible_to(scope)
    anonymous = object.project.has_anonymous_peer_review?
    unless evaluations.nil?
      ActiveModel::ArraySerializer.new(evaluations, each_serializer: EvaluationSerializer, :scope => scope, :anonymous => anonymous)
    else
      []
    end
  end

  def path
    if object.creator_type == 'Group'
      path_args = {:course_id => object.course_id, :project_id => object.project_id, :creator_id => object.creator_id}
      course_group_evaluations_path path_args
    elsif object.creator_type == 'User'
      course_user_evaluations_path :course_id => object.course_id, :project_id => object.project_id, :creator_id => object.creator_id
    end
  end

  def serialized_state
    'full'
  end

  protected


  def current_user_is_instructor
    if object.course.role(scope) == :evaluator then
      true
    else
      false
    end
  end

  def current_user_can_read_evaluations
    current_user_is_owner || current_user_is_instructor || scope.role == :administrator
  end

  def thumb
    object.thumb()
  end

  def url
    object.url()
  end

  # TODO: Revisit this, perhaps once active_model_serializers v9 is more stable.
  def evaluated_by_instructor?
    if scope.role?(:administrator) || scope.role?(:evaluator)
      object.evaluated_by_instructor?
    else
      false
    end
  end

  def peer_score_percentage
    if scope.role?(:administrator) || scope.role?(:evaluator)
      object.peer_score_percentage
    else
      0
    end
  end

end
