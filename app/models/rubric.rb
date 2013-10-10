require 'json'
require 'securerandom'

class Rubric < ActiveRecord::Base

  attr_accessible :name, :public, :description, :cells, :fields, :ranges
  belongs_to :owner, :class_name => "User"
  has_many :projects

  serialize :cells
  serialize :fields
  serialize :ranges

  validates :name, :owner, :presence => true

  scope :publicly_visible, where(:public => true)
  scope :public_or_owned_by, lambda { |owner| where('owner_id = ? OR public = true', owner)}

  def active_model_serializer
    RubricSerializer
  end

  def average_total_score()
    Evaluation.includes(:project).where(projects: {rubric_id: self}).average('total_score')
  end

  def average_total_percentage()
    Evaluation.includes(:project).where(projects: {rubric_id: self}).average('total_percentage')
  end

  def add_field(hash = {})
    self.fields = [] unless self.fields.kind_of? Array
    if hash.has_key?('id') || hash['id'].blank?
	    hash['id'] = hash['name'].parameterize
    end
    self.fields.push hash
    hash['id']
  end

  def add_range(hash)
	  self.ranges = [] unless self.ranges.kind_of? Array
	  if hash.has_key?('id') || hash['id'].blank?
		  hash['id'] = hash['name'].parameterize
	  end
	  self.ranges.push hash
		hash['id']
  end

  def add_cell(hash = {})
	  self.cells = [] unless self.cells.kind_of? Array
	  self.cells.push hash
	  hash['id']
  end

  def add_cells(cells)
    cells.each do |cell|
      add_cell(cell)
    end
  end

  def get_cell(field_key, range_key)
    self.cells.select{ |r| r['field'] == field_key && r['range'] == range_key}
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
    self.ranges.collect { |value| value['low'].to_i }.min
  end

  def points_possible
    fields.count * high_score
  end

  def high_score
    self.ranges.collect { |value| value['high'].to_i }.max
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
