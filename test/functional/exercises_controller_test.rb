require 'test_helper'

class ExercisesControllerTest < ActionController::TestCase
  context "search" do
    setup do
      @user1 = FactoryGirl.create(:user)
      @user2 = FactoryGirl.create(:user)
      @user3 = FactoryGirl.create(:user)

      @task1 = FactoryGirl.create(:task)
      @task2 = FactoryGirl.create(:task)
      @task3 = FactoryGirl.create(:task)

      [@user1, @user2, @user3].each do |user|
        [@task1, @task2, @task3].each do |task|
          FactoryGirl.create(:exercise, :user_id => user.id, :task_id => task.id, :date => (user == @user3) ? Date.yesterday : Date.current)
        end
      end

      sign_in(@user1)
    end

    should "return newest records if no conditions passed in" do
      get :index

      assert_equal 9, assigns(:exercises).size
    end

    should "return results by given conditions" do
      get :index, :user_id => @user1.id, :task_id => @task1.id, :date => Date.current

      assert_equal 1, assigns(:exercises).size
    end

    should "exercises by given date" do
      get :index, :date => Date.yesterday

      assert_equal 3, assigns(:exercises).size
      assert_equal [@user3.id], assigns(:exercises).map(&:user_id).uniq
    end
  end

  should "copy content from last one" do
    @user = FactoryGirl.create(:user)
    @task = FactoryGirl.create(:task)
    @date = Date.current
    sign_in(@user)

    previous_one = Exercise.create!(:user_id => @user.id, :task_id => @task.id, :date => Date.yesterday, :content => "last one content")

    get :new, :task_id => @task.id
    assert_equal "last one content", assigns(:exercise).content
  end
end
