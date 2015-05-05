# == Schema Information
#
# Table name: rubrics
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  public          :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  owner_id        :integer
#  description     :text
#  organization_id :integer
#  course_id       :integer
#  cells           :text
#  fields          :text
#  ranges          :text
#  high            :integer
#  low             :integer
#

class RubricSerializer < ActiveModel::Serializer
  attributes :id, :name, :fields, :ranges, :cells, :low, :high, :points_possible, :description, :public
end
