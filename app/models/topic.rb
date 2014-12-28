class Topic < ActiveRecord::Base
  attr_accessible :content, :title

  has_many :replies
  belongs_to :author, :class_name => "User"
  scope :recent_five, includes(:replies).limit(5).order("updated_at DESC")

  validates :title, :content, :author, :presence => true
end
