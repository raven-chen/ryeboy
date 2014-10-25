class Exercise < ActiveRecord::Base
  attr_accessible :content, :date, :task_id, :user_id

  belongs_to :user
  belongs_to :task
  has_many :comments, :inverse_of => :exercise

  validates :user, :task, :date, :presence => :true
  validates_uniqueness_of :date, :scope => [:user_id, :task_id]
  validate :unique_for_common_task, :on => :create

  def unique_for_common_task
    return true if !task.common

    errors.add(:user_id, I18n.t("activerecord.errors.messages.answer_on_common_task_should_be_unique")) if Exercise.exists?(:task_id => task.id, :user_id => user.id)
  end

  def copy_content_from_previous_one
    self.content = previous_one.content if previous_one
  end

  def self.on_date date
    where(:date => date)
  end

  def self.newest
    order("updated_at DESC").limit(20)
  end

  def quick_logged?
    content.blank?
  end

  def previous_one
    self.class.where(:user_id => user_id, :task_id => task_id).order("date DESC").limit(1).try(:first)
  end

  def content
    read_attribute(:content).try(:html_safe)
  end

  class << self
    def unfinished_user task, start_date, end_date
      result = []

      User.all.each do |user|
        result << user unless (start_date..end_date).all? { |date| exercise_finished?(user, date, task) }
      end

      result
    end

    def exercise_finished? user, date, task
      user.exercises.where(:date => date, :task_id => task.id).present?
    end
  end
end
