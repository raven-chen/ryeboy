require 'test_helper'

class ExerciseTest < ActiveSupport::TestCase
  should "one user could only create a task at one day" do
    user = FactoryGirl.create(:user)
    task = FactoryGirl.create(:task)
    date = Date.current

    Exercise.create!(:user_id => user.id, :task_id => task.id, :date => date, :content => "test")

    dup_exercise = Exercise.new(:user_id => user.id, :task_id => task.id, :date => date, :content => "test")
    assert !dup_exercise.valid?
    assert !dup_exercise.save
  end
end
