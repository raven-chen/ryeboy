class Topic < ActiveRecord::Base
  attr_accessible :content, :title

  has_many :replies
  belongs_to :author, :class_name => "User"

  validates :title, :content, :author, :presence => true
end
