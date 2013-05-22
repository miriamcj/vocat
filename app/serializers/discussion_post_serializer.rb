class DiscussionPostSerializer < ActiveModel::Serializer
  attributes :id, :author_id, :author_name, :body, :published, :parent_id, :gravatar, :created_at, :month, :day, :year, :time

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


  def gravatar
    gravatar_id = Digest::MD5.hexdigest(object.author.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?d=mm&s="
  end

end
