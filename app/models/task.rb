class Task < ActiveRecord::Base
  attr_accessible :description, :name, :common, :due_date, :required, :visible_to_admin_only

  validates :name, :presence => true

  has_many :users, :through => :exercises
  has_many :exercises

  scope :common, where(:common => true).order("updated_at DESC")
  scope :daily, where("common IS NOT TRUE").order("updated_at DESC")

  def finished? user
    date = due_date.present? ? due_date : Date.tomorrow
    exercises.where("date <= ? AND user_id = ?", date, user.id).present?
  end
end
