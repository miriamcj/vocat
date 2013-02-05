class Video < ActiveRecord::Base
  attr_accessible :description, :name, :path, :upload_date
end
