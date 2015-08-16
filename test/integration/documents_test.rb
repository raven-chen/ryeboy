require "test_helper"

class DocumentsTest < ActionDispatch::IntegrationTest
  setup do
    @mentor = FactoryGirl.create(:user)
    @mentor.roles = ["mentor", "documenter"]
    @mentor.save!
  end

  test "basic work flow of add comment to document" do
    document = FactoryGirl.create(:document)
    my_comment = "my comment on document"
    edited_comment = "my comment on document edited"

    login @mentor

    visit documents_path

    click_link document.name

    fill_in_editor my_comment
    click_button I18n.t("helpers.submit")

    sleep 1

    assert page.has_content?(my_comment)
    assert_equal my_comment, document.comments.last.content

    # edit comment
    find("div.content").click # trigger hover event to make edit link visible
    click_link I18n.t("helpers.edit")

    fill_in_editor edited_comment
    click_button I18n.t("helpers.submit")
    sleep 1

    assert_equal document_path(document), current_path
    assert page.has_content?(edited_comment)
    assert_equal edited_comment, document.comments.last.reload.content

    # delete comment
    find("div.content").click # trigger hover event to make edit link visible
    click_link I18n.t("helpers.delete")
    sleep 1
    page.driver.browser.switch_to.alert.accept
    sleep 1

    assert_equal document_path(document), current_path
    assert page.has_no_content?(edited_comment)
    assert document.comments.blank?
  end
end
