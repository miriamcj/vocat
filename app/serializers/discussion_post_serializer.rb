class DiscussionPostSerializer < ActiveModel::Serializer

  include ActionView::Helpers::TextHelper

  attributes :id, :author_id, :author_name, :body, :published, :parent_id, :gravatar, :created_at, :month, :day, :year, :time,
             :current_user_can_reply, :current_user_can_destroy

  def body
    simple_format(object.body)
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
    "http://gravatar.com/avatar/#{gravatar_id}.png?d=mm&s="
  end

end
