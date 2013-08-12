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


  #def set_field_and_ranges_from_params(fields, ranges)
  #
  #  clear_rubric()
  #
  #  if ranges.respond_to?('each')
  #    ranges.each do |range|
  #      self.add_range({
  #        :low => range['low'],
  #        :high => range['high'],
  #        :key => range['id'],
  #        :name => range['name']
  #      })
  #    end
  #  end
  #  if fields.respond_to?('each')
  #    fields.each do |field|
  #      self.add_field({
  #        :name => field['name'],
  #        :key => field['id'],
  #        :description => field['description']
  #      })
  #      if field['range_descriptions'].respond_to?('each')
  #        field['range_descriptions'].each do |range_key, description|
  #          self.add_range_description_for_field(range_key, field['id'], description)
  #        end
  #      end
  #    end
  #  end
  #end

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
