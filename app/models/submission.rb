class Submission < ActiveRecord::Base

  has_one :course, :through => :project

  has_many :assets, :dependent => :destroy
  has_many :evaluations, :dependent => :destroy
  has_many :discussion_posts, :dependent => :destroy
  belongs_to :project
  belongs_to :creator, :polymorphic => true
  belongs_to :user, -> { where "submissions.creator_type = 'User'" }, foreign_key: 'creator_id'
  belongs_to :group, -> { where "submissions.creator_type = 'Group'" }, foreign_key: 'creator_id'

  validates_presence_of :project_id, :creator_id, :creator_type

  delegate :department, :to => :course, :prefix => true
  delegate :number, :to => :course, :prefix => true
  delegate :name, :to => :course, :prefix => true
  delegate :section, :to => :course, :prefix => true
  delegate :name_long, :to => :course, :prefix => true
  delegate :allows_peer_review?, :to => :project, :prefix => true
  delegate :allows_self_evaluation?, :to => :project, :prefix => true
  delegate :id, :to => :course, :prefix => true
  delegate :name, :to => :project, :prefix => true
  delegate :rubric, :to => :project
  delegate :name, :to => :creator, :prefix => true

  default_scope { includes(:assets, :evaluations, :project) }

  scope :with_assets, -> { joins(:assets) }
  scope :for_courses, ->(course) { joins(:project)
                                       .where('projects.course_id' => course)
                                       .where('(creator_id in (?) AND creator_type = \'User\') OR (creator_id in (?) AND creator_type = \'Group\')', course.creators.pluck(:id), course.groups.ids)
  }

  def active_model_serializer
    SubmissionSerializer
  end

  def thumb
    first_asset.thumbnail
  end

  def first_asset
    assets.sorted.first
  end

  def evaluated_by_instructor?()
    instructor_evaluation_count > 0
  end

  def evaluated_by_peers?()
    peer_evaluation_count > 0
  end

  def new_posts_for_user?(user)
    last_post = discussion_posts.order(:created_at).last
    return false if last_post.nil?
    return last_post.created_at > user.last_sign_in_at
  end

  def peer_evaluations
    self.evaluations.published.created_by(self.course.creators.to_a)
  end

  def peer_score_total
    evaluations = self.peer_evaluations
    score_total(evaluations)
  end

  def peer_score_percentage
    total_score = peer_score_total
    total_count = peer_evaluation_count
    score_percentage(total_score, total_count)
  end

  def peer_evaluation_count
    self.peer_evaluations.count
  end

  def instructor_evaluations
    self.evaluations.published.created_by(self.course.evaluators.to_a)
  end

  def instructor_score_total
    evaluations = self.instructor_evaluations
    score_total(evaluations)
  end

  def instructor_evaluation_count
    self.instructor_evaluations.count
  end

  def instructor_score_percentage
    Evaluation::Calculator.average_percentage_for_submission(self, Evaluation::EVALUATION_TYPE_EVALUATOR)
  end

  def user_evaluation(user)
    self.evaluations.created_by(user).first()
  end

  def user_score_total(user)
    if evaluated_by_user?(user)
      user_evaluation(user).total_score
    end
  end

  def evaluated_by_user?(user)
    user_evaluation_count(user) > 0
  end

  def user_evaluation_published?(user)
    if evaluated_by_user?(user)
      user_evaluation(user).published
    end
  end

  def user_evaluation_count(user)
    self.evaluations.created_by(user).count
  end

  def has_asset?
    assets_count > 0
  end

  def has_rubric?
    !rubric.nil?
  end

  def evaluations_visible_to(user)
    role = course.role(user)
    # Admins and evaluators for the course can see everything
    if role == :administrator
      return evaluations
    elsif role == :evaluator
      return evaluations
    else
      if user.can?(:own, self)
        # User is the submission owner, so can see own evaluation plus any published evaluations
        return evaluations.where("evaluator_id = ? OR published = true", user.id)
      else
        return evaluations.where("evaluator_id = ?", user.id)
      end
    end
  end

  def reassign_to!(target_creator, type = 'exchange')
    source_creator = creator
    factory = SubmissionFactory.new
    target_submission = factory.one_by_creator_and_project(target_creator, self.project)
    if target_submission
      source_submission = self
      source_submission.creator = target_creator
      if type == 'exchange'
        target_submission.creator = source_creator
        ActiveRecord::Base.transaction do
          source_submission.save()
          target_submission.save()
        end
      elsif type == 'replace'
        target_submission.destroy
        source_submission.save()
      end
      target_submission
    else
      #TODO: Handle target submission does not exist error
    end
  end


  private

  def score_total(evaluations)
    sum = 0.0
    evaluations.each do |evaluation|
      sum = sum + evaluation.total_percentage
    end
    sum
  end

  def score_percentage(total_score, total_count)
    if total_score >= 0 && total_count > 0
      (total_score.to_f / total_count).to_i()
    else
      0
    end
  end


end
