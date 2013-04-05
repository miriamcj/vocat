class ProjectSerializer < ActiveModel::Serializer
  attributes  :id, :name, :course_name, :course_name_long, :course_id, :current_user_is_owner

  def current_user_is_owner
    #TODO: Complete this method
    false
  end

end
