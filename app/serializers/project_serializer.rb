class ProjectSerializer < ActiveModel::Serializer

  # See https://github.com/rails/rails/pull/13152
  include ActionView::Helpers::OutputSafetyHelper
  include ActionView::Helpers::TextHelper

  attributes  :id, :name, :current_user_is_owner, :course_name, :course_name_long,
              :course_id, :course_department, :course_section, :course_number,
              :current_user_id, :description, :evaluatable, :is_group_project

  has_one :rubric

  def evaluatable
    object.evaluatable
  end

  def current_user_is_owner
    Ability.new(scope).can?(:update, object)
  end

  def description
    simple_format(object.description)
  end

  def current_user_id
    scope.id
  end

end
