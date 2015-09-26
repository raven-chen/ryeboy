require "test_helper"

class NotificationsTest < ActionDispatch::IntegrationTest
  setup do
    @student_grade_1 = FactoryGirl.create(:user, grade: User::GRADES[0])
    @student_grade_2 = FactoryGirl.create(:user, grade: User::GRADES[1])
  end

  {"new_features" => 0, "new_notices" => 1}.each do |category, index|
    context "#{category}" do
      should "standard work flow" do
        notification = FactoryGirl.create(:notification, category: Notification::CATEGORIES[index], name: category, content: "#{category} content")

        login @student_grade_1

        assert page.has_content?(I18n.t("notifications.#{category}_%count_html", count: 1))

        trigger_class = (index == 0 ? ".newFeatures" : ".newNotices")
        find(trigger_class).click

        sleep 1
        assert page.has_content?(notification.name)
        assert page.has_content?(notification.content)
        assert @student_grade_1.reload.send("read_#{category}_at").present?

        visit root_path

        sleep 1
        assert page.has_no_content?(I18n.t("notifications.#{category}_%count_html", count: 1))
      end

      should "visible to all users when notification's grade is blank" do
        notification = FactoryGirl.create(:notification, category: Notification::CATEGORIES[index], grade: nil)

        login @student_grade_1

        assert page.has_content?(I18n.t("notifications.#{category}_%count_html", count: 1))

        logout
        login @student_grade_2

        assert page.has_content?(I18n.t("notifications.#{category}_%count_html", count: 1))
      end

      should "visible to user that belongs to notification's grade only" do
        notification = FactoryGirl.create(:notification, category: Notification::CATEGORIES[index], grade: User::GRADES[0])

        login @student_grade_1

        assert page.has_content?(I18n.t("notifications.#{category}_%count_html", count: 1))

        logout
        login @student_grade_2

        assert page.has_no_content?(I18n.t("notifications.#{category}_%count_html", count: 1))
      end
    end
  end

  test "new features and new notices appears at same time" do
    new_features = FactoryGirl.create(:notification, category: Notification::CATEGORIES[0])
    new_notices = FactoryGirl.create(:notification, category: Notification::CATEGORIES[1])

    login @student_grade_1

    assert page.has_content?(I18n.t("notifications.new_features_%count_html", count: 1))
    assert page.has_content?(I18n.t("notifications.new_notices_%count_html", count: 1))

    find(".newFeatures").click

    sleep 1
    assert page.has_content?(new_features.name)
    assert page.has_content?(new_features.content)
    assert @student_grade_1.reload.read_new_features_at.present?

    click_button I18n.t("helpers.close")

    find(".newNotices").click

    sleep 1
    assert page.has_content?(new_notices.name)
    assert page.has_content?(new_notices.content)
    assert @student_grade_1.reload.read_new_notices_at.present?

    visit root_path

    sleep 1
    assert page.has_no_content?(I18n.t("notifications.new_notices_%count_html", count: 1))
    assert page.has_no_content?(I18n.t("notifications.new_features_%count_html", count: 1))
  end
end
