class Exercise < ActiveRecord::Base
  attr_accessible :content, :date, :task_id, :user_id, :ask_for_comment, :visible_to_mentor_only

  belongs_to :user
  belongs_to :task
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :fans, :through => :interests, :class_name => "User", :source => :user, :dependent => :destroy
  has_many :interests

  validates :user, :task, :date, :presence => :true
  validates_uniqueness_of :date, :scope => [:user_id, :task_id]
  validate :unique_for_common_task, :on => :create

  scope :visible_to, lambda { |user|
    (user.present? && user.generalized_mentor?) ? all : where(visible_to_mentor_only: false)
  }

  scope :no_comment, -> { where(comments_count: 0) }

  after_touch :set_comments_count

  def set_comments_count
    self.comments_count = comments.count
    self.save!
  end

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
    self.class.where(:user_id => user_id, :task_id => task_id).where("content IS NOT NULL").order("date DESC").limit(1).try(:first)
  end

  def content
    read_attribute(:content).try(:html_safe)
  end

  class << self
    def unfinished_user grade, tasks, start_date, end_date
      result = []
      date_range = start_date..end_date
      users = grade ? User.where(grade: grade) : User.visible
      exercises = Exercise.where(date: date_range).to_a

      users.each do |user|
        user_name = user.name
        user_result = {user_name => {}}
        (start_date..end_date).each do |date|
          user_result[user_name][date.to_s] = {}
          tasks.each do |task|
            user_result[user_name][date.to_s][task.name] = exercise_finished?(exercises, user, date, task)
          end
        end

        result << user_result
      end

      result
    end

    def exercise_finished? exercises, user, date, task
      exercises.any?{|exercise| exercise.user_id == user.id && exercise.date == date && exercise.task_id == task.id}
    end
  end
end
