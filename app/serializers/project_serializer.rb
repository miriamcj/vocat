class ProjectSerializer < ActiveModel::Serializer

  # See https://github.com/rails/rails/pull/13152
  include ActionView::Helpers::OutputSafetyHelper
  include ActionView::Helpers::TextHelper

  attributes  :id, :name, :description, :listing_order_position, :type, :rubric_id, :rubric_name

  #has_one :rubric

  def description
    simple_format(object.description)
  end

  def current_user_id
    scope.id
  end

end
