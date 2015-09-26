class Notification < ActiveRecord::Base
  attr_accessible :active, :content, :grade, :category, :name

  default_scope where(:active => true).order("updated_at DESC")
  scope :unread, lambda{ |read_at| where("updated_at > ?", read_at || Date.new(2000,1,1)) }
  scope :applicable, lambda{ |grade| where("grade IS NULL OR grade = '' OR grade = ?", grade) }

  CATEGORIES = ["功能更新", "通知"]

  validates_inclusion_of :category, in: CATEGORIES
  validates_inclusion_of :grade, in: User::GRADES, allow_blank: true
end
