class Organization < ActiveRecord::Base
  attr_accessible :name
  has_many :courses

  def to_s
    name
  end
end
