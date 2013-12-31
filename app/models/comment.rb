class Comment < ActiveRecord::Base
  attr_accessible :content, :exercise_id

  belongs_to :exercise
  belongs_to :author, :class_name => "User"
end
