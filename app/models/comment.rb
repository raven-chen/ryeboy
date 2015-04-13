class Comment < ActiveRecord::Base
  attr_accessible :content, :exercise_id, :read_at, :replied_comment_id

  belongs_to :exercise, :inverse_of => :comments
  belongs_to :author, :class_name => "User"
  belongs_to :user

  # Self relation
  has_many :comments, class_name: "Comment", foreign_key: "replied_comment_id"
  belongs_to :replied_comment, class_name: "Comment"

  validates_presence_of :exercise, :author, :user
  validate :comment_reply_must_belongs_to_same_exercise, :if => lambda{ |c| c.reply_to_comment? }

  before_validation {
    # user_id means the exercise's author that needs to be notified
    self.user_id = reply_to_comment? ? replied_comment.author_id : exercise.user_id
  }

  scope :master_comments, includes(:exercise => [:task, :user]).where(:author_id => User.master.try(:id)).order("updated_at DESC")
  scope :received, lambda { |user| includes(:author, :exercise => [:task, :user]).where(:user_id => user.id).order("updated_at DESC") }
  scope :unread, lambda { |user| includes(:author, :exercise => [:task, :user]).where(:user_id => user.id, :read_at => nil).order("updated_at DESC") }

  def reply_to_comment?
    replied_comment.present?
  end

  def self.unread_count user
    where(:user_id => user.id, :read_at => nil).count
  end

  def comment_reply_must_belongs_to_same_exercise
    errors.add(:exercise_id, "comment reply must belongs to same exercise") unless replied_comment.exercise_id == exercise_id
  end
end
