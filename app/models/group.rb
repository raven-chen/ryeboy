class Group < ActiveRecord::Base
  attr_accessible :description, :name

  has_many :users

  validates :name, :presence => true
end
