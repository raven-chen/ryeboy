class UserTask < ActiveRecord::Base
  belongs_to :user
  belongs_to :task

  validates :task, :user, :presence => true
  validate :common_task_cannot_be_added

  def common_task_cannot_be_added
    errors.add(:task_id, I18n.t("notices.common_task_cannot_be_added")) if task.common?
  end
end
