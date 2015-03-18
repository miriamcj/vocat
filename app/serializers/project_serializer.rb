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
              :allows_public_discussion?,
              :rejects_past_due_media?,
              :allowed_attachment_families,
              :allowed_extensions,
              :allowed_mime_types,
              :type,
              :rubric_id,
              :rubric_name,
              :abilities,
              :course_id,
              :due_date

  has_one :rubric

  def evaluatable_by_peers?
    object.allows_peer_review?
  end

  def evaluatable_by_creator?()
    object.allows_self_evaluation?
  end

  def allows_public_discussion?()
    object.allows_public_discussion?
  end

  def description
    markdown = Redcarpet::Markdown.new(Renderer::InlineHTML.new({escape_html: true}))
    markdown.render(object.description)
  end

  def current_user_id
    scope.id
  end

  def abilities
    {
        can_update: Ability.new(scope).can?(:update, object),
        can_destroy: Ability.new(scope).can?(:destroy, object),
        can_evaluate: Ability.new(scope).can?(:evaluate, object),
        can_show_submissions: Ability.new(scope).can?(:show_submissions, object)
    }
  end

end
