require 'json'
require 'securerandom'

class Rubric < ActiveRecord::Base

  belongs_to :owner, :class_name => "User"
  has_many :projects
  has_many :courses, :through => :projects
  has_many :evaluations

  serialize :cells, Array
  serialize :fields, Array # A field is {'name' => 'name', 'description' => 'description'}
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
  scope :public_or_owned_by, -> (owner) { where('owner_id = ? OR public = true', owner)}

  # Params is a hash of search values including (:department || :semester || :year) || :section
  def self.search(params)
    r = Rubric.all
    r
  end

  def ensure_fields()
    self.fields = [] unless self.fields.kind_of? Array
    self.fields.map! {|field| field.with_indifferent_access}
  end

  def ensure_ranges()
    self.ranges = [] unless self.ranges.kind_of? Array
    self.ranges.map! {|range| range.with_indifferent_access}
  end

  def ensure_cells()
    self.cells = [] unless self.cells.kind_of? Array
    self.cells.map! {|cell| cell.with_indifferent_access}

  end

  def clone()
    rubric = self.dup
    rubric.public = false
    rubric.owner.delete unless rubric.owner.nil?
    rubric.projects.delete
    rubric.name << ' - cloned'
    rubric
  end

  def active_model_serializer
    RubricSerializer
  end

  def average_total_score()
    Evaluation.includes(:project).where(projects: {rubric_id: self}).average('total_score')
  end

  def average_total_percentage()
    Evaluation.includes(:project).where(projects: {rubric_id: self}).average('total_percentage')
  end

  def average_total_peer_percentage()
    Evaluation.includes(:project, :evaluator).where(projects: {rubric_id: self}).where(users: {role: 'creator'}).average('total_percentage')
  end

  def average_total_instructor_percentage()
    Evaluation.includes(:project, :evaluator).where(projects: {rubric_id: self}).where(users: {role: 'evaluator'}).average('total_percentage')
  end

  def evaluation_count()
    Evaluation.includes(:project, :evaluator).where(projects: {rubric_id: self}).where(published: true).count()
  end

  def score_percentage_by_field_and_range

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
    self.cells.find{ |r| r['field'] == field_key && r['range'] == range_key}
  end

  def range_description_key(range_key, field_key)
    "#{range_key}/#{field_key}"
  end

  def get_low_for_range(range)
		range = self.ranges.select{ |r| r['id'] == range }
		if range != nil
			range.low
		else
			nil
		end
  end

  def get_high_for_range(range)
	  range = self.ranges.select{ |r| r['id'] == range }
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

  def field_names
    self.fields.collect { |value| value['name']}
  end

  def field_keys
	  self.fields.collect { |value| value['id']}
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

  def to_s
    self.name
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
