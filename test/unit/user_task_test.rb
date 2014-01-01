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
end
