require "test_helper"

class GuestsTest < ActionDispatch::IntegrationTest
  context "guest's permissions" do
    should "can access exercises, topics and documents" do
      visit root_path

      assert page.has_content?(I18n.t("menus.exercises"))
      assert page.has_content?(I18n.t("menus.topics"))
      assert page.has_content?(I18n.t("menus.documents"))

      click_link I18n.t("menus.exercises")
      sleep 1
      assert page.has_content?(I18n.t("titles.newest_exercises"))

      click_link I18n.t("menus.topics")
      sleep 1
      assert page.has_content?(I18n.t("titles.topics"))

      click_link I18n.t("menus.documents")
      sleep 1
      assert page.has_content?(I18n.t("titles.documents"))
    end
  end
end
