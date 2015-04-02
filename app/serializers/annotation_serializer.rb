class AnnotationSerializer < ActiveModel::Serializer
  attributes :id, :asset_id, :author_id, :body, :published, :seconds_timecode, :smpte_timecode, :author_name, :canvas,
             :current_user_can_destroy, :current_user_can_edit, :gravatar, :author_role, :created_at, :created_at_timestamp,
             :body_raw

  def current_user_can_destroy
    Ability.new(scope).can?(:destroy, object)
  end

  def current_user_can_edit
    Ability.new(scope).can?(:update, object)
  end

  def author_role
    course = object.asset.submission.course
    course.role(object.author)
  end

  def body
    markdown = Redcarpet::Markdown.new(Renderer::InlineHTML.new({escape_html: true}))
    markdown.render(object.body)
  end

  def body_raw
    object.body
  end

  def gravatar
    gravatar_id = Digest::MD5.hexdigest(object.author.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?d=mm&s="
  end

  def created_at
    object.created_at.strftime("%-m/%d/%y %I:%M%p")
  end

  def created_at_timestamp
    object.created_at.to_i
  end

end
