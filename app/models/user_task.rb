class UserTask < ActiveRecord::Base
  belongs_to :user
  belongs_to :task

  validates :task, :user, :presence => true
  validate :common_task_cannot_be_added, :check_grade

  def common_task_cannot_be_added
    errors.add(:task_id, I18n.t("notices.common_task_cannot_be_added")) if task.common?
  end

  def check_grade
    return true if task.grade.blank?

    errors.add(:user_id, I18n.t("notices.incorrect_grade_for_current_user")) if task.grade != user.grade
  end
end
