class Reply < ActiveRecord::Base
  attr_accessible :content, :topic_id

  belongs_to :topic
  belongs_to :author, :class_name => "User"

  validates :author_id, :content, :topic_id, :presence => true
end
