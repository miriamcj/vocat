class Rubric < ActiveRecord::Base

  attr_accessible :name, :public, :description
  belongs_to :owner, :class_name => "User"
  has_many :projects

  serialize :fields, ActiveRecord::Coders::Hstore
  serialize :field_sorting, ActiveRecord::Coders::Hstore
  serialize :field_descriptions, ActiveRecord::Coders::Hstore
  serialize :ranges, ActiveRecord::Coders::Hstore
  serialize :range_lows, ActiveRecord::Coders::Hstore
  serialize :range_highs, ActiveRecord::Coders::Hstore
  serialize :range_descriptions, ActiveRecord::Coders::Hstore

  scope :public, where(:public => true)
  scope :public_or_owned_by, lambda { |owner| where('owner_id = ? OR public = true', owner)}

  def active_model_serializer
    RubricSerializer
  end

  def set_field_and_ranges_from_params(fields, ranges)
    if ranges.respond_to?('each')
      ranges.each do |range|
        self.add_range({
          :low => range['low'],
          :high => range['high'],
          :key => range['id'],
          :name => range['name']
        })
      end
    end
    if fields.respond_to?('each')
      fields.each do |field|
        self.add_field({
          :name => field['name'],
          :key => field['id'],
          :description => field['description']
        })
        if field['range_descriptions'].respond_to?('each')
          field['range_descriptions'].each do |range_key, description|
            self.add_range_description_for_field(range_key, field['id'], description)
          end
        end
      end
    end
  end

  def add_field(options = {})
    options.has_key?(:key) && !options[:key].blank? ? key = options[:key] : key = options[:name].parameterize
    self.fields[key] = options[:name]
    if !options[:description].blank?
      self.field_descriptions[key] = options[:description]
    end
    key
  end

  def add_range(options = {})
    options.has_key?(:key) && !options[:key].blank? ? key = options[:key] : key = options[:name].parameterize
    self.ranges[key] = options[:name]
    if options.has_key?(:descriptions) && options[:descriptions].respond_to?('each')
      options[:descriptions].each do |field_key, value|
        self.add_range_description_for_field(key, field_key, value)
      end
    end
    if options.has_key?(:low)
      self.range_lows[key] = options[:low]
    end
    if options.has_key?(:high)
      self.range_highs[key] = options[:high]
    end
    key
  end

  def range_description_key(range_key, field_key)
    "#{range_key}/#{field_key}"
  end

  def add_range_description_for_field(range, field, desc)
    key = self.range_description_key(range, field)
    self.range_descriptions[key] = desc
  end

  def is_private_rubric?
    !self.is_public_rubric?
  end

  def is_public_rubric?
    self.public
  end

  def field_names
    self.fields.values
  end

  def field_keys
    self.fields.keys
  end

  def range_low(range)
    self.range_lows[range]
  end

  def range_high(range)
    self.range_highs[range]
  end

  def range_description(range, field)
    key = self.range_description_key(range, field)
    self.range_descriptions[key]
  end

  def low_score
    self.range_lows.values.min.to_i
  end

  def points_possible
    fields.count * high_score
  end

  def high_score
    self.range_highs.values.max.to_i
  end


end
