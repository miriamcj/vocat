class Asset < ActiveRecord::Base

  belongs_to :submission
  belongs_to  :author, :class_name => 'User'
  has_many :annotations, :dependent => :destroy
  has_one :attachment, :dependent => :destroy

  delegate :processing_error, :to => :attachment, :prefix => false, :allow_nil => true

  # We don't want any typeless assets being created.
  validates_presence_of :type

  # def active_model_serializer
  #   AssetSerializer
  # end

end
