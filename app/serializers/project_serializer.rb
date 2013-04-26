class ProjectSerializer < ActiveModel::Serializer
  attributes  :id, :name, :current_user_is_owner, :course_name, :course_name_long,
              :course_id, :course_department, :course_section, :course_number


  def current_user_is_owner
    #TODO: Complete this method
    false
  end

end
