class ProjectSerializer < ActiveModel::Serializer

  include ActionView::Helpers::TextHelper

  attributes  :id, :name, :current_user_is_owner, :course_name, :course_name_long,
              :course_id, :course_department, :course_section, :course_number,
              :current_user_id, :description, :evaluatable

  has_one :rubric

  def evaluatable
    object.evaluatable
  end

  def current_user_is_owner
    Ability.new(scope).can?(:update, object)
  end

  def description
    object.description
# TODO: Determine why this shows an error.
#    simple_format(object.description)
  end

  def current_user_id
    scope.id
  end

end
