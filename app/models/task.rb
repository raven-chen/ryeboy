class Task < ActiveRecord::Base
  attr_accessible :description, :name

  has_many :users, :through => :exercises
  has_many :exercises
end
