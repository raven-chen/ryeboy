class Document < ActiveRecord::Base
  attr_accessible :author_id, :content, :name, :category

  belongs_to :author, :class_name => "User", :foreign_key => :author_id

  validates :name, :category, :content, :presence => true

  CATEGORIES = ["心法", "实用", "规则", "聊天记录"]
  validates_inclusion_of :category, in: CATEGORIES

  def category_enum
    CATEGORIES
  end
end
