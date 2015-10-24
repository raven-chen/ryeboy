require "test_helper"

class GuestsTest < ActionDispatch::IntegrationTest
  context "guest's permissions" do
    should "can access exercises, topics and documents" do
      visit root_path

      assert page.has_content?(I18n.t("menus.exercises"))
      assert page.has_content?(I18n.t("menus.topics"))

      within(".navbar") { click_link I18n.t("menus.exercises") }
      sleep 1
      assert_equal I18n.t("menus.exercises"), find(".nav li.selected a").text

      click_link I18n.t("menus.topics")
      sleep 1
      assert_equal I18n.t("menus.topics"), find(".nav li.selected a").text
    end
  end
end
