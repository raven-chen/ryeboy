class Topic < ActiveRecord::Base
  attr_accessible :content, :title, :category

  has_many :replies
  belongs_to :author, :class_name => "User"
  scope :recent_five, includes(:replies).limit(5).order("updated_at DESC")

  validates :title, :content, :author, :presence => true

  CATEGORIES = ["反省改过", "心得体验", "问题求助", "资料分享", "方法推荐", "青春励志", "意见反馈", "其它分类"]
  validates_inclusion_of :category, in: CATEGORIES
end
