require "test_helper"

class CommentsTest < ActionDispatch::IntegrationTest
  setup do
    @task = FactoryGirl.create(:task)
    @mentor = FactoryGirl.create(:user)
    @mentor.roles = ["mentor"]
    @mentor.save!
    @student = FactoryGirl.create(:user)
    @student.my_tasks << @task
    @student.save!
  end

  test "Add comment and receiver should receive notice" do
    exercise = FactoryGirl.create(:exercise, :task => @task, :user => @student)
    comment_content = "this is a comment"

    login @mentor

    visit exercises_path

    within("li.item-container#exercise-#{exercise.id}") do
      click_link I18n.t("helpers.comment")

      fill_in "comment[content]", with: comment_content

      click_button I18n.t("helpers.submit")

      sleep 1

      assert page.has_content?(comment_content)
    end

    comment = Comment.last
    assert_equal comment_content, comment.content
    assert_equal @student, comment.user
    assert_equal @mentor, comment.author

    click_link I18n.t("helpers.logout")

    sleep 1
    login @student

    assert_equal "1", find("span.unread-count").text
  end
end
