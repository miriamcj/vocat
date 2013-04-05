class SubmissionSerializer < ActiveModel::Serializer
  attributes  :id, :name, :url, :thumb, :course_name, :course_name_long, :project_name,
              :course_id, :project_id, :creator_name, :creator_id, :user_is_owner

  def user_is_owner
		scope == object.creator
  end

  def thumb
		object.thumb()
  end

  def url
    object.url()
  end

end
