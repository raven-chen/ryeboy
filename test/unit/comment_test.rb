require "test_helper"

class CommentTest < ActiveSupport::TestCase
  setup do
    @user = FactoryGirl.create(:user)
    @task = FactoryGirl.create(:task)
    @date = Date.current
    @exercise = Exercise.create!(:user_id => @user.id, :task_id => @task.id, :date => @date, :content => "test")
    @exercise2 = Exercise.create!(:user_id => @user.id, :task_id => @task.id, :date => Date.yesterday, :content => "test")
  end

  should "comment reply must belongs to same exercise" do
    comment = FactoryGirl.create(:comment, :commentable => @exercise)
    replied_comment = FactoryGirl.build(:comment, :commentable => @exercise2, :replied_comment_id => comment.id)

    assert replied_comment.invalid?
  end
end
