# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  role                   :string(255)
#  organization_id        :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  first_name             :string(255)
#  last_name              :string(255)
#  middle_name            :string(255)
#  settings               :text
#  org_identity           :string(255)
#  gender                 :string(255)
#  city                   :string(255)
#  state                  :string(255)
#  country                :string(255)
#  is_ldap_user           :boolean
#  preferences            :hstore           default({}), not null
#

class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :gravatar, :first_name, :last_sign_in_at, :org_identity, :list_name

  def gravatar
    gravatar_id = Digest::MD5.hexdigest(object.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?d=mm&s="
  end

end
