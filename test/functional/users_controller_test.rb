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

  context "add tag" do
    setup do
      @hr = FactoryGirl.build(:user)
      @hr.roles = ["hr"]
      @hr.save!
      @current_user = FactoryGirl.create(:user)
      @other_user = FactoryGirl.create(:user)
      @skill_tag = "skill"
      @tags = "tag1,tag2"

      @tags_params = {tags: @tags, tag_type: @skill_tag, id: nil}
    end

    should "hr can add tag to other user" do
      sign_in @hr

      post :add_tag, @tags_params.merge(id: @other_user.id)

      assert_response :created
      assert_equal @tags, @other_user.send("#{@skill_tag}_list").join(",")
    end

    should "user can add tag to itself" do
      sign_in @current_user

      post :add_tag, @tags_params.merge(id: @current_user.id)

      assert_response :created
      assert_equal @tags, @current_user.send("#{@skill_tag}_list").join(",")
    end

    should "non hr user can't add tag to other user" do
      sign_in @current_user

      post :add_tag, @tags_params.merge(id: @other_user.id)

      assert_response :bad_request
      assert @current_user.send("#{@skill_tag}_list").exclude?(@tags.first)
    end

    should "not allow undefined tag tag_type to be added" do
      sign_in @current_user

      post :add_tag, @tags_params.merge(id: @current_user.id, tag_type: "unknown")

      assert_response :bad_request
      assert @current_user.send("#{@skill_tag}_list").exclude?(@tags.first)
    end
  end
end
