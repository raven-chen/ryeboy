class Exercise < ActiveRecord::Base
  attr_accessible :content, :date, :task_id, :user_id, :ask_for_comment, :visible_to_mentor_only, :rater_id, :score, :rated_at

  belongs_to :user
  belongs_to :task
  belongs_to :rater, class_name: "User", foreign_key: "rater_id", dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :fans, :through => :interests, :class_name => "User", :source => :user, :dependent => :destroy
  has_many :interests

  validates :user, :task, :date, :presence => :true
  validates_uniqueness_of :date, :scope => [:user_id, :task_id]
  validates_numericality_of :score, :greater_than => 0, :less_than => 11, :only_integer => true, :allow_blank => true
  validate :unique_for_common_task, :on => :create
  validate :check_rating

  scope :visible_to, lambda { |user|
    (user.present? && user.generalized_mentor?) ? all : where(visible_to_mentor_only: false)
  }

  scope :no_comment, -> { where(comments_count: 0) }
  scope :no_score, -> { where(score: nil) }

  after_touch :set_comments_count

  def set_comments_count
    self.comments_count = comments.count
    self.save!
  end

  def check_rating
    if score.present?
      errors.add(:rater_id, "评分人不可为空") if rater.blank?
      errors.add(:scored_at, "评分时间不可为空") if scored_at.blank?
    end
  end

  def unique_for_common_task
    return true if !task.common

    errors.add(:user_id, I18n.t("activerecord.errors.messages.answer_on_common_task_should_be_unique")) if Exercise.exists?(:task_id => task.id, :user_id => user.id)
  end

  def copy_template_from_task
    self.content = task.template
  end

  def self.on_date date
    where(:date => date)
  end

  def self.newest
    order("updated_at DESC").limit(20)
  end

  def rated?
    rater && score && scored_at
  end

  def previous_one
    self.class.where(:user_id => user_id, :task_id => task_id).where("content IS NOT NULL").order("date DESC").limit(1).try(:first)
  end

  def read_task attr_name, bool_return = false
    if task.present?
      task.send(attr_name)
    else
      bool_return ? false : "功课已删除"
    end
  end

  def content= val
    if val && !val.valid_encoding?
      val = val.encode("UTF-8", invalid: :replace, replace: "?")
    end

    write_attribute(:content, val)
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
