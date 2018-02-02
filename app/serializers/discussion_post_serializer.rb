# == Schema Information
#
# Table name: discussion_posts
#
#  id            :integer          not null, primary key
#  published     :boolean
#  author_id     :integer
#  parent_id     :integer
#  body          :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  submission_id :integer
#

class DiscussionPostSerializer < ActiveModel::Serializer

  # See https://github.com/rails/rails/pull/13152
  include ActionView::Helpers::OutputSafetyHelper
  include ActionView::Helpers::TextHelper

  attributes :id, :author_id, :author_name, :body, :body_raw, :published, :parent_id, :gravatar, :created_at, :month, :day, :year, :time,
             :current_user_can_reply, :current_user_can_destroy, :submission_id

  def body
    markdown = Redcarpet::Markdown.new(Renderer::InlineHTML.new({escape_html: true}))
    markdown.render(object.body)
  end

  def body_raw
    object.body
  end

  def month
    object.created_at.strftime("%b")
  end

  def day
    object.created_at.strftime("%d")
  end

  def year
    object.created_at.strftime("%Y")
  end

  def time
    object.created_at.strftime("%I:%M %p")
  end

  def current_user_can_reply
    Ability.new(scope).can?(:reply, object)
  end

  def current_user_can_destroy
    Ability.new(scope).can?(:destroy, object)
  end

  def gravatar
    gravatar_id = Digest::MD5.hexdigest(object.author.email.downcase)
    "https://gravatar.com/avatar/#{gravatar_id}.png?d=mm&s="
  end

end
