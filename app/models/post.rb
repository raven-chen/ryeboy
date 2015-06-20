class Post < ActiveRecord::Base
  attr_accessible :author, :author_id, :category, :content, :name

  has_many :comments, as: :commentable
  belongs_to :author, class_name: "User"

  validates :name, :author, :category, presence: true

  CATEGORIES = ["通知", "资料中心", "教研部", "人力部", "传媒部", "运营部", "院办"]
  validates_inclusion_of :category, in: CATEGORIES

  def category_enum
    CATEGORIES
  end

  def user_id
    author.id
  end
end
