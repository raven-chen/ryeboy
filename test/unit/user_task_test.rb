require "test_helper"

class UserTaskTest < ActiveSupport::TestCase
  setup do
    @user = FactoryGirl.create(:user)
    @task1 = FactoryGirl.create(:task, common: true)
    @task2 = FactoryGirl.create(:task)
  end

  should "be able to add personal task to my tasks" do
    @user.my_tasks << @task2
    @user.save!

    assert @user.my_tasks.include?(@task2)
  end

  should "not be able to add common task to my tasks" do
    user_task = UserTask.new
    user_task.user = @user
    user_task.task = @task1

    assert !user_task.valid?
    assert_equal I18n.t("notices.common_task_cannot_be_added"), user_task.errors[:task_id].first
  end

  context "grade check" do
    should "allow grade task to be added by user" do
      @user.update_attributes!({grade: User::GRADES[0]})
      @task2.update_attributes!({grade: User::GRADES[0]})

      @user.my_tasks << @task2
      @user.save!
      assert @user.my_tasks.include?(@task2)
    end

    should "disallow non-grade task to be added by user" do
      @user.update_attributes!({grade: User::GRADES[0]})
      @task2.update_attributes!({grade: User::GRADES[1]})

      user_task = UserTask.new
      user_task.user = @user
      user_task.task = @task2

      assert !user_task.valid?
      assert_equal I18n.t("notices.incorrect_grade_for_current_user"), user_task.errors[:user_id].first
    end

    should "allow task has no grade to be added by user" do
      @user.update_attributes!({grade: User::GRADES[0]})
      @task1.update_attributes!({grade: nil})

      @user.my_tasks << @task2
      @user.save!
      assert @user.my_tasks.include?(@task2)
    end
  end
end
