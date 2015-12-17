class Topic < ActiveRecord::Base
  attr_accessible :content, :title, :category

  has_many :replies
  has_many :comments, as: :commentable, dependent: :destroy
  belongs_to :author, :class_name => "User"
  scope :recent_five, -> { includes(:comments).limit(5).order("updated_at DESC") }

  validates :title, :content, :author, :presence => true

  CATEGORIES = ["蜕变案例", "学员互动", "问题求助", "精品微信"]
  validates_inclusion_of :category, in: CATEGORIES

  def user_id
    author.id
  end
end
