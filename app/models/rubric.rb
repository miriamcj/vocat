class Rubric < ActiveRecord::Base
  attr_accessible :name, :public, :fields, :ranges, :description
  belongs_to :owner, :class_name => "User"
  has_many :projects

  serialize :fields, Array
  serialize :ranges, Array

  def is_private_rubric?
    !self.is_public_rubric?
  end

  def is_public_rubric?
    self.public
  end




end
