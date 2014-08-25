class Comment < ActiveRecord::Base
  attr_accessible :content, :exercise_id, :read_at

  belongs_to :exercise, :inverse_of => :comments
  belongs_to :author, :class_name => "User"
  belongs_to :user

  validates_presence_of :exercise, :author, :user

  before_validation {
    self.user_id = exercise.user_id
  }

  scope :master_comments, includes(:exercise => [:task, :user]).where(:author_id => User.master.id).order("updated_at DESC")
  scope :received, lambda { |user| includes(:exercise => [:task, :user], :author => []).where(:user_id => user.id).order("updated_at DESC") }
  scope :unread, lambda { |user| includes(:exercise => [:task, :user], :author => []).where(:user_id => user.id, :read_at => nil).order("updated_at DESC") }

  def self.unread_count user
    where(:user_id => user.id, :read_at => nil).count
  end
end
