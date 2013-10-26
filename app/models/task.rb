class Task < ActiveRecord::Base
  attr_accessible :description, :name

  validates :name, :presence => true

  has_many :users, :through => :exercises
  has_many :exercises
end
