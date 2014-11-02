class Interest < ActiveRecord::Base
  belongs_to :user
  belongs_to :exercise

  validates :user, :exercise, :presence => true
  validates_uniqueness_of :user_id, scope: :exercise_id

  after_create {
    exercise.fan += 1
    exercise.save!
  }

  before_destroy {
    exercise.fan -= 1
    exercise.save!
  }
end
