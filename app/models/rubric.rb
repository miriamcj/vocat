require 'json'

class Rubric < ActiveRecord::Base

  attr_accessible :name, :public, :description, :cells, :fields, :ranges
  belongs_to :owner, :class_name => "User"
  has_many :projects

  serialize :cells, ActiveRecord::Coders::Hstore
  serialize :fields, ActiveRecord::Coders::Hstore
  serialize :ranges, ActiveRecord::Coders::Hstore

  validates :name, :owner, :presence => true

  scope :publicly_visible, where(:public => true)
  scope :public_or_owned_by, lambda { |owner| where('owner_id = ? OR public = true', owner)}

  def active_model_serializer
    RubricSerializer
  end

  before_save :serialize_hstores
  after_save :unserialize_hstores
  after_initialize :unserialize_hstores

  def serialize_hstores
    self.ranges.each do |key, hash|
      self.ranges[key] = hash.to_json
    end
    self.fields.each do |key, hash|
      self.fields[key] = hash.to_json
    end
    self.cells.each do |key, hash|
      self.cells[key] = hash.to_json
    end
  end

  def unserialize_hstores
    self.ranges.each do |key, hash|
      if hash.is_a? String then self.ranges[key] = JSON.parse(hash) end
    end
    self.fields.each do |key, hash|
      if hash.is_a? String  then self.fields[key] = JSON.parse(hash) end
    end
    self.cells.each do |key, hash|
      if hash.is_a? String  then self.cells[key] = JSON.parse(hash) end
    end
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

  def add_field(options = {})
    self.fields = {} unless self.fields
    options.has_key?(:key) && !options[:key].blank? ? key = options[:key] : key = options[:name].parameterize
    self.fields[key] = { name: options[:name], description: options[:description] }
    key
  end

  def add_range(options = {})
    self.ranges = {} unless self.ranges
    options.has_key?(:key) && !options[:key].blank? ? key = options[:key] : key = options[:name].parameterize
    self.ranges[key] = { name: options[:name], description: options[:description], low: options[:low], high: options[:high] }
    key
  end

  def add_cell(options = {})
    self.cells = {} unless self.cells
    if !options.has_key?(:range) || !options.has_key?(:field) || !ranges.has_key?(options[:range]) || !fields.has_key?(options[:field])
      raise 'Unable to add cell with corresponding field and/or rubric already present in the rubric'
    else
      key = get_cell_key(options[:field], options[:range])
      self.cells[key] = { description: options[:description], range: options[:range], field: options[:field] }
    end
  end

  def add_cells(cells)
    cells.each do |cell|
      add_cell(cell)
    end
  end

  def get_cell(field_key, range_key)
    key = get_cell_key(field_key, range_key)
    self.cells[key]
  end

  def range_description_key(range_key, field_key)
    "#{range_key}/#{field_key}"
  end

  def get_low_for_range(range)
    self.ranges[range]['low']
  end

  def get_high_for_range(range)
    self.ranges[range]['high']
  end

  def is_private_rubric?
    !self.is_public_rubric?
  end

  def is_public_rubric?
    self.public
  end

  def field_names
    self.fields.collect { |key, value| value['name']}
  end

  def field_keys
    self.fields.keys
  end

  def low_score
    self.ranges.collect { |key, value| value['low'].to_i }.min
  end

  def points_possible
    fields.count * high_score
  end

  def high_score
    self.ranges.collect { |key, value| value['high'].to_i }.max
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
