class Task < ActiveRecord::Base
  attr_accessible :description, :name, :common, :due_date, :required, :visible_to_admin_only, :grade, :template

  validates :name, :presence => true
  validates_inclusion_of :grade, in: User::GRADES, allow_nil: true

  has_many :users, :through => :exercises
  has_many :exercises

  scope :common, -> { where(:common => true).order("updated_at DESC") }
  scope :daily, -> { where("common IS NOT TRUE").order("updated_at DESC") }
  scope :applicable, lambda { |user| where("grade IS NULL OR grade = ?", user.grade).order("updated_at DESC") }

  before_validation { |t|
    t.grade = nil if t.grade.blank?
  }

  def finished_by? user
    date = due_date.present? ? due_date : Date.tomorrow
    exercises.where("date <= ? AND user_id = ?", date, user.id).present?
  end

  def grade_enum
    User::GRADES
  end
end
