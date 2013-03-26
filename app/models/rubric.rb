class Rubric < ActiveRecord::Base
  attr_accessible :name, :public, :fields, :ranges, :description
  serialize :fields, Array
  serialize :ranges, Array
end
