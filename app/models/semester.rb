# == Schema Information
#
# Table name: semesters
#
#  id         :integer          not null, primary key
#  name       :string
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#  start_date :date
#  end_date   :date
#

# Essentially a value object, although at some point admins will be able to manage these.
class Semester < ApplicationRecord

  belongs_to :organization

  scope :sorted, -> { order(start_date: :desc) }
  scope :in_org, ->(org) { where(:organization => org) }

  validates :organization_id, :name, presence: true

  before_save :valid_dates

  def valid_dates
    if start_date >= end_date
      errors.add(:semester, 'start date must be before end date')
      throw :abort
    end
  end

  def self.search(params)
    s = Semester.all
    s = s.find_by_year(params[:year]) unless params[:year].blank?
    s = s.where({organization_id: params[:organization_id]}) unless params[:organization_id].blank?
    s
  end

  def self.find_by_year(year)
    self.where('extract(year from start_date) = ?', year)
  end

  def self.unique_years
    self.pluck("distinct extract(year from start_date)::Integer").sort!
  end

  def to_s
    name
  end

  def year
    start_date.year
  end

end
