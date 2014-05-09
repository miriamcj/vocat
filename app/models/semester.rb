# Essentially a value object, although at some point admins will be able to manage these.
class Semester < ActiveRecord::Base

  def to_s
    name
  end

end
