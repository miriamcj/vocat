class Organization < ActiveRecord::Base

  has_many :courses

  def to_s
    name
  end
end
