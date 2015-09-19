require "test_helper"

class TopicsTest < ActionDispatch::IntegrationTest
  setup do
    @student1 = FactoryGirl.create(:user, { roles: ["student"] })
    @student2 = FactoryGirl.create(:user, { roles: ["student"] })
    @student3 = FactoryGirl.create(:user, { roles: ["student"] })
  end

  test "student1 create topic, student2 reply to topic, student3 reply to student2" do
    topic = FactoryGirl.build(:topic)
    topic.author = @student1
    topic.save!

    login @student2

    visit topic_path(topic)

    fill_in_editor "reply"
    submit_form

    assert_equal @student2.comments.last, topic.comments.last

    logout

    login @student3
    visit topic_path(topic)

    click_on I18n.t("helpers.reply")
    fill_in_editor "reply"
    submit_form

    assert_equal @student3.comments.last.replied_comment, @student2.comments.last
    assert page.has_content?("回复 #{@student2.name}:")
  end
end
