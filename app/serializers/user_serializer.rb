# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  role                   :string
#  organization_id        :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  first_name             :string
#  last_name              :string
#  middle_name            :string
#  settings               :text
#  org_identity           :string
#  gender                 :string
#  city                   :string
#  state                  :string
#  country                :string
#  is_ldap_user           :boolean
#  preferences            :hstore           default({}), not null
#
# Indexes
#
#  index_users_on_email_and_organization_id  (email,organization_id) UNIQUE
#  index_users_on_organization_id            (organization_id)
#  index_users_on_reset_password_token       (reset_password_token) UNIQUE
#

class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :gravatar, :first_name, :last_sign_in_at, :org_identity, :list_name

  def gravatar
    gravatar_id = Digest::MD5.hexdigest(object.email.downcase)
    "https://gravatar.com/avatar/#{gravatar_id}.png?d=mm&s="
  end

end
