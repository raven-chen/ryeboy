require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create(:user)

    @task = FactoryGirl.create(:task)
    @exercise = FactoryGirl.create(:exercise, :task => @task, :user => @user)
    @comment = FactoryGirl.create(:comment, :commentable => @exercise)

    sign_in @user
  end

  test "Enter index page should set comment's read_at" do
    get :index

    assert_response :success
    assert_not_nil @comment.reload.read_at
  end
end
