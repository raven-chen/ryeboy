require "test_helper"

class ExercisesTest < ActionDispatch::IntegrationTest
  setup do
    @task = FactoryGirl.create(:task)
    @mentor = FactoryGirl.create(:user)
    @mentor.roles = ["mentor"]
    @mentor.save!
  end

  test "log a exercise" do
    @mentor.my_tasks << @task
    @mentor.save!

    login @mentor

    page.find(:css, "div.active .task-#{@task.id}").click

    fill_in_editor "test"

    click_button I18n.t("helpers.submit")
    sleep 1

    assert @mentor.exercises.present?
    assert_equal "test", @mentor.exercises.last.content
    assert_equal Date.current, @mentor.exercises.last.date
  end
end
