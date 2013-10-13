class Exercise < ActiveRecord::Base
  attr_accessible :content, :date, :task_id, :user_id

  belongs_to :user
  belongs_to :task

  validates :user, :task, :date, :content, :presence => :true
end
