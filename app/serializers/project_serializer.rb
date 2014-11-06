class ProjectSerializer < ActiveModel::Serializer

  # See https://github.com/rails/rails/pull/13152
  include ActionView::Helpers::OutputSafetyHelper
  include ActionView::Helpers::TextHelper

  attributes  :id,
              :name,
              :description,
              :listing_order_position,
              :evaluatable?,
              :evaluatable_by_peers?,
              :evaluatable_by_creator?,
              :type,
              :rubric_id,
              :rubric_name,
              :abilities,
              :course_id

  #has_one :rubric

  def description
    simple_format(object.description)
  end

  def current_user_id
    scope.id
  end

  def abilities
    {
        can_update: Ability.new(scope).can?(:update, object),
        can_destroy: Ability.new(scope).can?(:destroy, object)
    }
  end

end
