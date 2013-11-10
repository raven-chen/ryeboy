class UserTask < ActiveRecord::Base
  attr_accessible :task_id, :user_id

  belongs_to :user
  belongs_to :task
end
