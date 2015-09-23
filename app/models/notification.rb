class Notification < ActiveRecord::Base
  attr_accessible :active, :content, :grade, :category, :name

  scope :active, where(:active => true).order("updated_at DESC")

  CATEGORIES = ["功能更新", "通知"]

  validates_inclusion_of :category, in: CATEGORIES
  validates_inclusion_of :grade, in: User::GRADES, allow_blank: true
end
