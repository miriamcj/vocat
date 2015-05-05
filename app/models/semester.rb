# == Schema Information
#
# Table name: semesters
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#

# Essentially a value object, although at some point admins will be able to manage these.
class Semester < ActiveRecord::Base

  def to_s
    name
  end

end
