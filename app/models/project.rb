# == Schema Information
#
# Table name: projects
#
#  id                          :integer          not null, primary key
#  name                        :string
#  description                 :text
#  course_id                   :integer
#  project_type_id             :integer
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  rubric_id                   :integer
#  listing_order               :integer
#  type                        :string           default("user")
#  due_date                    :date
#  allowed_attachment_families :text             default([]), is an Array
#  settings                    :hstore           default({}), not null
#
# Indexes
#
#  index_projects_on_course_id        (course_id)
#  index_projects_on_project_type_id  (project_type_id)
#

class Project < ApplicationRecord

  include RankedModel
  ranks :listing_order, :with_same => :course_id

  belongs_to :course
  belongs_to :rubric, optional: true
  has_many :submissions, :dependent => :destroy
  has_many :evaluations, :through => :submissions
  has_many :discussion_posts, :through => :submissions
  has_many :assets, :through => :submissions

  delegate :name, :to => :rubric, :prefix => true, :allow_nil => true
  delegate :avg_score, :to => :rubric, :prefix => true, :allow_nil => true
  delegate :avg_percentage, :to => :rubric, :prefix => true, :allow_nil => true

  delegate :department, :to => :course, :prefix => true
  delegate :number, :to => :course, :prefix => true
  delegate :name, :to => :course, :prefix => true
  delegate :section, :to => :course, :prefix => true
  delegate :name_long, :to => :course, :prefix => true
  delegate :id, :to => :course, :prefix => true

  ALLOWED_SETTINGS = [:enable_creator_attach, :enable_self_evaluation, :enable_peer_review, :enable_public_discussion, :reject_past_due_media, :anonymous_peer_review]
  BOOLEAN_SETTINGS = [:enable_creator_attach, :enable_self_evaluation, :enable_peer_review, :enable_public_discussion, :reject_past_due_media, :anonymous_peer_review]
  ATTACHMENT_FAMILIES = %w(audio image video)

  store_accessor :settings, *ALLOWED_SETTINGS
  after_initialize :ensure_settings
  before_save :clean_settings

  validates :course, :name, :description, :presence => true
  validate :attachment_families_are_valid

  default_scope { includes(:course) }
  scope :unsubmitted_for_user_and_course, ->(creator, course) { joins('LEFT OUTER JOIN submissions ON submissions.project_id = projects.id AND submissions.creator_id = ' + creator.id.to_s).where('submissions.creator_id IS NULL AND course_id IN (?)', course) }

  def average_peer_score
    self.evaluations.of_type('1').average('total_percentage')
  end

  def average_instructor_score
    self.evaluations.of_type('2').average('total_percentage')
  end

  def average_self_score
    self.evaluations.self_evaluations.average('total_percentage')
  end

  def discussion_posts_count
    self.discussion_posts.count
  end

  def annotations_count
    Annotation.by_project(self).count
  end

  def assets_count
    self.assets.count
  end

  def video_assets_count
    self.submissions.with_video_assets.count
  end

  def attachment_families_are_valid
    if self.allowed_attachment_families
      self.allowed_attachment_families = self.read_attribute(:allowed_attachment_families).uniq
      self.allowed_attachment_families.each do |value|
        unless Project::ATTACHMENT_FAMILIES.include?(value)
          errors.add(:allowed_attachment_families, "contains an invalid value \"#{value}\"")
        end
      end
    end
  end

  def ensure_settings
#    self.settings = {} unless self.settings.kind_of? Hash
  end

  def clean_settings
    Project::BOOLEAN_SETTINGS.each do |bool_setting|
      setting_key = bool_setting.to_s
      value = settings[setting_key].to_s.downcase
      if value == "1" || value == "true"
        settings[setting_key] = '1'
      else
        settings[setting_key] = '0'
      end
    end
  end


  def active_model_serializer
    ProjectSerializer
  end

  def allowed_attachment_families
    allowed = read_attribute(:allowed_attachment_families)
    if allowed.blank? || allowed.length == 0
      allowed = Project::ATTACHMENT_FAMILIES
    end
    allowed
  end

  def allowed_extensions
    Attachment::Inspector::extensions_for allowed_attachment_families
  end

  def allowed_mime_types
    Attachment::Inspector::mime_types_for allowed_attachment_families
  end

  def published_evaluations_by_type(type)
    evaluations.published.of_type(type).includes(:submission)
  end

  def published_evaluations_by_evaluator(user)
    evaluations.published.created_by(user).includes(:submission)
  end

  def published_evaluations
    evaluations.where(published: true).includes(:submission)
  end

  def publish_evaluations(user)
    evaluations.where(:evaluator_id => user).update_all(:published => true)
  end

  def unpublish_evaluations(user)
    evaluations.where(:evaluator_id => user).update_all(:published => false)
  end

  def evaluation_count_by_user(user)
    Evaluation.joins(:submission).where(:evaluator_id => user, :submissions => {project_id: self}).count
  end

  def avg_score()
    Evaluation.includes(:project).where(projects: {id: self}).average('total_score') || 0
  end

  def avg_percentage()
    Evaluation.includes(:project).where(projects: {id: self}).average('total_percentage') || 0
  end

  # TODO: Not happy with this
  def statistics()
    {
        assets_count: assets_count,
        video_assets_count: video_assets_count,
        discussion_posts_count: discussion_posts_count,
        annotations_count: annotations_count,
        possible_submission_count: possible_submissions_count,
        rubric_avg_score: rubric_avg_score,
        rubric_avg_percentage: rubric_avg_percentage
    }
  end

  def submission_by_user(user)
    submissions.where(:creator_id => user.id).first
  end

  def evaluatable?()
    !rubric.nil?
  end

  def to_s()
    self.name
  end

  def possible_submissions_count
    Course.count_possible_submissions_for(self)
  end

  def type_human()
    raise NotImplementedError
  end

  def accepts_group_submissions?
    raise NotImplementedError
  end

  def accepts_user_submissions?
    raise NotImplementedError
  end

  def allows_public_discussion?
    get_boolean_setting_value('enable_public_discussion')
  end

  def allows_peer_review?
    get_boolean_setting_value('enable_peer_review')
  end

  def allows_self_evaluation?
    get_boolean_setting_value('enable_self_evaluation')
  end

  def allows_creator_attach?
    get_boolean_setting_value('enable_creator_attach')
  end

  def rejects_past_due_media?
    get_boolean_setting_value('reject_past_due_media')
  end

  def has_anonymous_peer_review?
    get_boolean_setting_value('anonymous_peer_review')
  end

  private

  def get_boolean_setting_value(key)
    if settings.has_key?(key)
      value = settings[key]
      return true if value == true || value =~ (/^(true|t|yes|y|1)$/i)
      return false if value == false || value.blank? || value =~ (/^(false|f|no|n|0)$/i)
    else
      return false
    end
  end


end
