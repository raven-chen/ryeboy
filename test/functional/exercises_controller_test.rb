require 'test_helper'

class ExercisesControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create(:user)
    @task = FactoryGirl.create(:task)
    @date = Date.current
    sign_in(@user)
  end

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
          FactoryGirl.create(:exercise, :user_id => user.id, :task_id => task.id, :date => (user == @user3) ? 8.days.ago : Date.current)
        end
      end
    end

    should "return recent 1 week records as default if no conditions passed in" do
      get :index

      assert_equal 6, assigns(:exercises).size
    end

    should "return results by given conditions" do
      get :index, user_id: @user1.id, task_id: @task1.id, from: Date.current, to: Date.current

      assert_equal 1, assigns(:exercises).size
    end

    should "exercises by given date" do
      get :index, from: 9.days.ago, to: 5.days.ago

      assert_equal 3, assigns(:exercises).size
      assert_equal [@user3.id], assigns(:exercises).map(&:user_id).uniq
    end
  end

  should "copy content from task template" do
    template = "task template"
    @task.update_attributes!({template: template})

    get :new, :task_id => @task.id
    assert_equal template, assigns(:exercise).content
  end

  context "Friendly notice of taken date" do
    should "add friendly notice when submitted exercise's date has been taken" do
      exist_exercise = Exercise.create!(:user_id => @user.id, :task_id => @task.id, :date => Date.yesterday, :content => "last one content")

      post :create, :exercise => {:user_id => @user.id, :task_id => @task.id, :date => Date.yesterday, :content => "new one content"}

      assert assigns(:exercise).errors.present?
      assert assigns(:edit_existing_exercise).present?
      assert_match /#{exist_exercise.id}/, assigns(:edit_existing_exercise)
    end

    should "do nothing if exercise invalid because of nil date" do
      exist_exercise = Exercise.create!(:user_id => @user.id, :task_id => @task.id, :date => Date.yesterday, :content => "last one content")

      post :create, :exercise => {:user_id => @user.id, :task_id => @task.id, :date => nil, :content => "new one content"}

      assert assigns(:exercise).errors.present?
      assert !assigns(:edit_existing_exercise).present?
    end
  end
end
