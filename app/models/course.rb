class Course < ActiveRecord::Base
  belongs_to :organization
  has_and_belongs_to_many :evaluators, :class_name => "User", :join_table => "courses_evaluators"
  has_and_belongs_to_many :assistants, :class_name => "User", :join_table => "courses_assistants"
  has_and_belongs_to_many :creators, :class_name => "User", :join_table => "courses_creators"
  has_many :projects
  has_many :rubrics
  has_many :groups
  has_one :project_type

  attr_accessible :department, :description, :name, :number, :section, :evaluators, :assistants, :creators, :settings

  serialize :settings, ActiveRecord::Coders::Hstore

  validates :department, :name, :number, :section, :presence => true
  validates :evaluators, :length => {:minimum => 1, :message => "can't be empty."}
  validates :creators, :length => {:minimum => 1, :message => "can't be empty."}

  default_scope order("department ASC, number ASC, section ASC")

  def name_long
		self.to_s
  end

  def to_s
    "#{department}#{number}: #{name}, Section #{section}"
  end

  # %n = number
  # %c = name
  # %s = section
  # %d = department
  def format(format)
    out = format.gsub("%n", number.to_s)
    out = out.gsub("%c", name)
    out = out.gsub("%s", section)
    out = out.gsub("%d", department)
  end

  def role(user)
    return :administrator if user.role? :admin
    return :creator if creators.include? user
    return :assistant if assistants.include? user
    return :evaluator if evaluators.include? user
  end

end
