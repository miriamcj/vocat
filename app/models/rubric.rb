# == Schema Information
#
# Table name: rubrics
#
#  id              :integer          not null, primary key
#  name            :string
#  public          :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  owner_id        :integer
#  description     :text
#  organization_id :integer
#  course_id       :integer
#  cells           :text
#  fields          :text
#  ranges          :text
#  high            :integer
#  low             :integer
#

require 'json'
require 'securerandom'

class Rubric < ApplicationRecord

  belongs_to :owner, :class_name => "User"
  belongs_to :organization
  has_many :projects, :dependent => :nullify
  has_many :courses, :through => :projects
  has_many :evaluations, :dependent => :destroy


  delegate :name, :to => :owner, :prefix => true, :allow_nil => true

  serialize :cells, Array
  serialize :fields, Array # A field is {'name' => 'name', 'id', description' => 'description'}
  serialize :ranges, Array # A range is {'low' => X, 'high' => X, 'name' => 'name'}

  validates :name, :owner, :low, :high, :presence => true
  validate :validate_ranges

  after_initialize :ensure_ranges
  after_initialize :ensure_fields
  after_initialize :ensure_cells

  def validate_ranges
    self.ranges.each do |range|
      errors.add(:ranges, "All Ranges must have a low value") unless range['low']
      errors.add(:ranges, "All Ranges must have a high value") unless range['high']
      errors.add(:ranges, "All Ranges must have a name") unless range['name']
      errors.add(:ranges, "Rubrics must have at least one range") unless range.length > 0
    end
  end

  scope :publicly_visible, -> { where(:public => true) }
  scope :public_or_owned_by, ->(owner) { where('owner_id = ? OR public = true', owner) }
  scope :in_org, ->(org) { where(:organization => org)}

  # Params is a hash of search values including (:department || :semester || :year) || :section
  def self.search(params)
    r = Rubric.all
    if params[:name] then
      r = r.where(["lower(name) LIKE :name", {:name => "#{params[:name].downcase}%"}])
    end
    if params[:public] == true || params[:public] == false then
      r = r.where(:public => params[:public])
    end
    r
  end

  # Currently, filters is a hash that should include start_year, end_year, start_semester, and end_semester (semester IDs)
  def evaluations_filtered(filters)
    e = evaluations
    if !filters[:start_year].blank? && !filters[:end_year].blank? && !filters[:start_semester].blank? && !filters[:end_semester].blank?
      e = e.joins(:project => {:course => :semester})
      start_year = filters[:start_year]
      end_year = filters[:end_year]
      start_position = Semester.find(filters[:start_semester]).position
      end_position = Semester.find(filters[:end_semester]).position
      if start_position > 0 && end_position > 0
        e = e.where(' (
                        (semesters.position >= :start_position AND courses.year = :start_year) AND
                        (semesters.position <= :end_position AND courses.year = :end_year)
                      ) OR (courses.year > :start_year AND courses.year < :end_year)',
                    {start_position: start_position, start_year: start_year, end_year: end_year, end_position: end_position})
      end
    end
    e
  end


  def ensure_fields()
    self.fields = [] unless self.fields.kind_of? Array
    self.fields.map! { |field| field.with_indifferent_access }
  end

  def ensure_ranges()
    self.ranges = [] unless self.ranges.kind_of? Array
    self.ranges.map! { |range| range.with_indifferent_access }
  end

  def ensure_cells()
    self.cells = [] unless self.cells.kind_of? Array
    self.cells.map! { |cell| cell.with_indifferent_access }
  end

  def clone()
    rubric = self.dup
    rubric.public = false
    rubric.owner = nil
    rubric.projects.delete
    rubric.name << ' - cloned'
    rubric
  end

  def active_model_serializer
    RubricSerializer
  end

  def avg_score
    Evaluation.includes(:project).where(projects: {rubric_id: self}).average('total_score')
  end

  def avg_percentage
    Evaluation.includes(:project).where(projects: {rubric_id: self}).average('total_percentage')
  end

  def avg_self_eval_percentage
    Evaluation.self_evaluations.where(rubric_id: self.id).average('total_percentage')
  end

  def average_total_peer_percentage
    Evaluation.includes(:project, :evaluator).where(projects: {rubric_id: self}).where(users: {role: 'creator'}).average('total_percentage')
  end

  def average_total_instructor_percentage
    Evaluation.includes(:project, :evaluator).where(projects: {rubric_id: self}).where(users: {role: 'evaluator'}).average('total_percentage')
  end

  def evaluation_count
    Evaluation.includes(:project, :evaluator).where(projects: {rubric_id: self}).where(published: true).count()
  end

  def add_field(hash = {})
    if hash.has_key?('id') || hash['id'].blank?
      hash['id'] = hash['name'].parameterize
    end
    self.fields.push hash
    hash['id']
  end

  def add_range(hash)
    if hash.has_key?('id') || hash['id'].blank?
      hash['id'] = hash['name'].parameterize
    end
    self.ranges.push hash
    hash['id']
  end

  def add_cell(hash = {})
    self.cells.push hash
    hash['id']
  end

  def add_cells(cells)
    cells.each do |cell|
      add_cell(cell)
    end
  end

  def get_cell(field_key, range_key)
    self.cells.find { |r| r['field'] == field_key && r['range'] == range_key }
  end

  def range_description_key(range_key, field_key)
    "#{range_key}/#{field_key}"
  end

  def get_low_for_range(range)
    range = self.ranges.select { |r| r['id'] == range }
    if range != nil
      range.low
    else
      nil
    end
  end

  def get_high_for_range(range)
    range = self.ranges.select { |r| r['id'] == range }
    if range != nil
      range.high
    else
      nil
    end

    self.ranges[range]['high']
  end

  def is_private_rubric?
    !self.is_public_rubric?
  end

  def is_public_rubric?
    self.public
  end

  def range_names
    self.ranges.collect { |value| value['name'] }
  end

  def range_names_downcase
    self.ranges.collect { |value| value['name'].downcase }
  end

  def field_names
    self.fields.collect { |value| value['name'].downcase }
  end

  def field_keys
    self.fields.collect { |value| value['id'] }
  end

  def field_name_for(key)
    f = self.fields.find { |f| f['id'] == key }
    if !f.nil?
      f['name']
    else
      nil
    end
  end

  def low_score
    self.low
  end

  def points_possible
    fields.count * high_score
  end

  def high_score
    self.high
  end

  def high_possible_for(field_key_)
    high_score
  end

  def low_possible_for(field_key)
    low_score
  end

  def to_s
    self.name
  end

  def avg_field_scores
    Evaluation.each_field_average(evaluations)
  end

  private

  def get_cell_key(field, range)
    "#{field}:#{range}"
  end

  def clear_rubric
    self.fields = {}
    self.ranges = {}
    self.cells = {}
  end

end
