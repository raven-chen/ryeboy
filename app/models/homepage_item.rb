class HomepageItem < ActiveRecord::Base
  attr_accessible :name, :category, :url, :sequence, :view_more

  CATEGORIES = ["恢复案例", "最新活动", "新手链接", "微信文章"]

  validates_inclusion_of :category, in: CATEGORIES
  validates_presence_of :name, :url
  validates_numericality_of :sequence, :greater_than_or_equal_to => 1, :only_integer => true
end
