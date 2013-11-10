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

  context "Unfinished exercises" do
    setup do
      Task.delete_all
      User.delete_all
      Exercise.delete_all

      @user1 = FactoryGirl.create(:user)
      @user2 = FactoryGirl.create(:user)
      @user3 = FactoryGirl.create(:user)

      @task1 = FactoryGirl.create(:task)
      @task2 = FactoryGirl.create(:task)
      @task3 = FactoryGirl.create(:task)

      @user1.my_tasks << [@task1, @task2, @task3]
      @user2.my_tasks << [@task1, @task2, @task3]

      @date = Date.today
    end

    should "Return blank hash if everyone are logged their exercise in time" do
      [@user1, @user2, @user3].each do |user|
        [@task1, @task2, @task3].each do |task|
          Exercise.create!(:user_id => user.id, :task_id => task.id, :date => @date, :content => "test")
        end
      end

      results = Exercise.unfinished_exercises [@user1, @user2, @user3], @date, @date
      assert results[@date].blank?
    end

    should "Return not finish exercises user's exercise log stats include not logged in time" do
      [@task1, @task2, @task3].each do |task|
        Exercise.create!(:user_id => @user1.id, :task_id => task.id, :date => @date, :content => "test") # User1 finished all exercise
      end

      # user2 finished task1 but not log task2 in time.
      Exercise.create!(:user_id => @user2.id, :task_id => @task1.id, :date => @date, :content => "test")
      not_log_in_time = Exercise.create!(:user_id => @user2.id, :task_id => @task2.id, :date => @date.yesterday, :content => "test")
      not_log_in_time.created_at = (@date.to_datetime + 19.hours)
      not_log_in_time.save!

      # user3 only has task 2 and 3 need to do. but he only finished task 2
      @user3.my_tasks << [@task2, @task3]
      Exercise.create!(:user_id => @user3.id, :task_id => @task2.id, :date => @date, :content => "test")

      results = Exercise.unfinished_exercises [@user1, @user2, @user3], @date.yesterday, @date

      assert_nil results[@date][@user1]
      assert results[@date][@user2][@task1]
      assert !results[@date][@user2][@task2]
      assert !results[@date][@user2][@task3]
      assert_nil results[@date][@user3][@task1]
      assert results[@date][@user3][@task2]
      assert !results[@date][@user3][@task3]
    end
  end
end
