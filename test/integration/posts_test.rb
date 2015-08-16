require "test_helper"

class PostsTest < ActionDispatch::IntegrationTest
  setup do
    @mentor = FactoryGirl.create(:user)
    @mentor.roles = ["mentor", "poster"]
    @mentor.save!
  end

  test "basic work flow of add comment to post" do
    post = FactoryGirl.create(:post)
    my_comment = "my comment on post"
    edited_comment = "my comment on post edited"

    login @mentor

    visit posts_path

    click_link post.name

    fill_in_editor my_comment
    click_button I18n.t("helpers.submit")

    sleep 1

    assert page.has_content?(my_comment)
    assert_equal my_comment, post.comments.last.content

    # edit comment
    find("div.content").click # trigger hover event to make edit link visible
    click_link I18n.t("helpers.edit")

    fill_in_editor edited_comment
    click_button I18n.t("helpers.submit")
    sleep 1

    assert_equal post_path(post), current_path
    assert page.has_content?(edited_comment)
    assert_equal edited_comment, post.comments.last.reload.content

    # delete comment
    find("div.content").click # trigger hover event to make edit link visible
    click_link I18n.t("helpers.delete")
    sleep 1
    page.driver.browser.switch_to.alert.accept
    sleep 1

    assert_equal post_path(post), current_path
    assert page.has_no_content?(edited_comment)
    assert post.comments.blank?
  end
end
