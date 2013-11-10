require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  context "Assign my task" do
    setup do
      @user = FactoryGirl.create(:user)

      @task1 = FactoryGirl.create(:task)
      @task2 = FactoryGirl.create(:task)
      @task3 = FactoryGirl.create(:task)

      sign_in @user
    end

    should "set my tasks by given tasks" do
      put :assign_my_tasks, :id => @user.id, :task_ids => [@task1.id, @task2.id, @task3.id]

      assert_redirected_to root_path
      assert_equal 3, @user.my_tasks.size
    end
  end
end
