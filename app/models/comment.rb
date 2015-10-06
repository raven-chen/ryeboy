class Comment < ActiveRecord::Base
  attr_accessible :content, :commentable, :commentable_id, :commentable_type, :read_at, :replied_comment_id

  belongs_to :commentable, polymorphic: true, touch: true
  belongs_to :author, :class_name => "User"
  belongs_to :user # receiver

  # Self relation
  has_many :comments, class_name: "Comment", foreign_key: "replied_comment_id", dependent: :destroy
  belongs_to :replied_comment, class_name: "Comment"

  validates_presence_of :commentable, :author, :user
  validate :comment_reply_must_belongs_to_same_resource, :if => lambda{ |c| c.reply_to_comment? }

  before_validation {
    raise "Commentable resource must have user_id defined" unless commentable.respond_to?(:user_id)
    # user_id means the resource's author that needs to be notified
    self.user_id = reply_to_comment? ? replied_comment.author_id : commentable.user_id
  }

  scope :received, lambda { |user| includes(:author).where(:user_id => user.id).order("updated_at DESC") }
  scope :unread, lambda { |user| includes(:author).where(:user_id => user.id, :read_at => nil).order("updated_at DESC") }

  def reply_to_comment?
    replied_comment.present?
  end

  def self.unread_count user
    where(:user_id => user.id, :read_at => nil).count
  end

  def comment_reply_must_belongs_to_same_resource
    errors.add(:commentable_id, "comment reply must belongs to same resource") unless replied_comment.commentable_id == commentable_id
  end
end
