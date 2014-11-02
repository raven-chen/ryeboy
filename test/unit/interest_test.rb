require "test_helper"

class InterestTest < ActiveSupport::TestCase
  setup do
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    task = FactoryGirl.create(:task)
    date = Date.current
    @exercise = Exercise.create!(:user_id => @user1.id, :task_id => task.id, :date => date, :content => "test")
  end

  should "one user could only like one exercise once" do
    @user2.liked_exercises << @exercise

    interest = Interest.new
    interest.user_id = @user2.id
    interest.exercise_id = @exercise.id
    assert !interest.save
  end

  should "after user liked one exercise, exercise.fan count should +1" do
    @user2.liked_exercises << @exercise
    @user2.save!

    assert_equal 1, @exercise.fan
  end

  should "after user disliked one exercise, exercise.fan count should -1" do
    @user2.liked_exercises << @exercise
    @user2.save!

    @user2.liked_exercises.delete(@exercise)

    assert_equal 0, @exercise.reload.fan
  end
end
