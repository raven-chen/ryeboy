class Exercise < ActiveRecord::Base
  attr_accessible :content, :date, :task_id, :user_id

  belongs_to :user
  belongs_to :task
  has_many :comments, :inverse_of => :exercise

  validates :user, :task, :date, :content, :presence => :true
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

  def previous_one
    self.class.where(:user_id => user_id, :task_id => task_id).order("date DESC").limit(1).try(:first)
  end

  def content
    read_attribute(:content).try(:html_safe)
  end

  class << self
    def unfinished_exercises users, start_date, end_date
      result = {}

      (start_date..end_date).each do |date|
        result[date] ||= {}

        users.each do |user|
          next if all_exercises_finished?(user, date)

          result[date].merge! exercises_stats(user, date)
        end
      end

      result
    end

    def all_exercises_finished? user, date
      user.my_tasks.blank? || (user.exercises.finished_on_date(date).size == user.my_tasks.size)
    end

    def exercise_finished? user, date, task
      user.exercises.where(:date => date, :task_id => task.id).present?
    end

    def exercises_stats user, date
      stats = {}; stats[user] = {}

      user.my_tasks.each{ |task| stats[user].merge!({task => exercise_finished?(user, date, task)}) }
      stats
    end
  end
end
