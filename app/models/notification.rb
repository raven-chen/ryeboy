class Notification < ActiveRecord::Base
  attr_accessible :active, :content, :grade, :category, :name

  default_scope where(:active => true).order("updated_at DESC")

  scope :unread, lambda{ |read_at, user_created_at| where("updated_at > ?", read_at || user_created_at) } # New user should not see legacy notifications
  scope :applicable, lambda{ |grade| where("grade IS NULL OR grade = '' OR grade = ?", grade) }

  CATEGORIES = ["功能更新", "通知"]

  validates_inclusion_of :category, in: CATEGORIES
  validates_inclusion_of :grade, in: User::GRADES, allow_blank: true
end
