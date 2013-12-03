class UserSerializer < ActiveModel::Serializer
	attributes :id, :email, :name, :gravatar, :first_name, :last_sign_in_at

  def gravatar
    gravatar_id = Digest::MD5.hexdigest(object.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?d=mm&s="
  end

end
