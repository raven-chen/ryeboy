class HomepageItem < ActiveRecord::Base
  attr_accessible :name, :category, :url, :sequence, :view_more

  CATEGORIES = ["恢复案例", "最新活动", "新手链接", "微信文章"]

  validates_inclusion_of :category, in: CATEGORIES
  validates_presence_of :name, :url
  validates_numericality_of :sequence, :greater_than_or_equal_to => 1, :only_integer => true

  validate :uniquence_of_true_view_more_option_in_category, if: lambda { |item| item.view_more }

  def uniquence_of_true_view_more_option_in_category
    errors.add(:view_more, I18n.t("notices.view_more_already_exists_in_%{category}", category: category)) if HomepageItem.where(category: category, view_more: true).count > 0
  end
end
