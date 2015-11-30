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

  should "common task's answer should be unique" do
    @task.update_attributes!({:common => true})
    Exercise.create!(:user_id => @user.id, :task_id => @task.id, :date => @date, :content => "test")
    exercise = Exercise.new(:user_id => @user.id, :task_id => @task.id, :date => Date.yesterday, :content => "test")

    assert !exercise.valid?
    assert_equal I18n.t("activerecord.errors.messages.answer_on_common_task_should_be_unique"), exercise.errors[:user_id].first
  end

  should "copy content from task's template" do
    template = "task template"
    @task.update_attributes!({template: template})

    new_exercise = Exercise.new(:user_id => @user.id, :task_id => @task.id, :date => @date)
    new_exercise.copy_template_from_task

    assert_equal template, new_exercise.content
  end

  should "copy nothing if task's template is blank" do
    new_exercise = Exercise.new(:user_id => @user.id, :task_id => @task.id, :date => @date)
    new_exercise.copy_template_from_task

    assert new_exercise.content.blank?
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

    should "select all users that didn't log given taks's exercise in given date range" do
      skip
    end
  end
end
