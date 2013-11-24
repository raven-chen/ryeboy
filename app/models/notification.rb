class Notification < ActiveRecord::Base
  attr_accessible :active, :content

  scope :active, where(:active => true)
end
