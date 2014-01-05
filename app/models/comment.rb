class Comment < ActiveRecord::Base
  attr_accessible :content, :exercise_id

  belongs_to :exercise
  belongs_to :author, :class_name => "User"

  # 58 is "yaxinlinglong@qq.com". Bad coding smell though >_>
  scope :master_comments, includes(:exercise => [:task, :user]).where(:author_id => 58).order("updated_at DESC")
end
