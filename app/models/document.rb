class Document < ActiveRecord::Base
  attr_accessible :author_id, :content, :name, :category

  belongs_to :author, :class_name => "User", :foreign_key => :author_id
  has_many :comments, as: :commentable

  validates :name, :category, :content, :author, :presence => true

  CATEGORIES = ["成功案例", "健康六步曲", "新手问答", "效果问答", "病症问答", "六步曲问答", "教学问答", "其它问答"]
  validates_inclusion_of :category, in: CATEGORIES

  def category_enum
    CATEGORIES
  end

  def user_id
    author_id
  end
end
