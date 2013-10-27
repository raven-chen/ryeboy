require "test_helper"

class ExerciseTest < ActiveSupport::TestCase
  setup do
    @user = FactoryGirl.create(:user)
    @task = FactoryGirl.create(:task)
    @date = Date.current
  end

  should "one user could only create a task at one day" do
    Exercise.create!(:user_id => @user.id, :task_id => @task.id, :date => @date, :content => "test")

    dup_exercise = Exercise.new(:user_id => @user.id, :task_id => @task.id, :date => @date, :content => "test")
    assert !dup_exercise.valid?
    assert !dup_exercise.save
  end

  should "copy content from last exercise" do
    previous_one = Exercise.create!(:user_id => @user.id, :task_id => @task.id, :date => Date.yesterday, :content => "last one content")

    new_exercise = Exercise.new(:user_id => @user.id, :task_id => @task.id, :date => @date)
    new_exercise.copy_content_from_previous_one

    assert_equal "last one content", new_exercise.content
  end
end
