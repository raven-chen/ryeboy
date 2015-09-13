require "test_helper"

class TasksTest < ActionDispatch::IntegrationTest
  context "Common task" do
    should "managed by dean" do
      dean = FactoryGirl.create(:user, {roles: ["mentor", "dean"]})
      task_name = "test"
      new_task_name = "updated test"
      task_description = "test content"
      task_grade = User::GRADES[2]

      login dean

      visit tasks_path

      click_on I18n.t("helpers.create_task")

      fill_in "task[name]", with: task_name
      select task_grade, from: "task[grade]"
      fill_in_editor task_description
      submit_form

      task = Task.common.last
      assert_equal task_name, task.name
      assert_equal task_description, task.description
      assert_equal task_grade, task.grade

      # Edit task
      within("#task-#{task.id}") { click_on I18n.t("helpers.edit") }

      fill_in "task[name]", with: new_task_name
      submit_form

      task.reload
      assert_equal new_task_name, task.name
      assert_equal task_description, task.description
      assert_equal task_grade, task.grade
    end

    should "disallow student to manage" do
      task = FactoryGirl.create(:task, common: true)
      student = FactoryGirl.create(:user, {roles: ["student"]})

      login student

      visit tasks_path

      assert page.has_no_content?(I18n.t("helpers.create_task")), "student can create task"
      assert page.has_no_content?(I18n.t("helpers.edit"))
    end

    should "answer task by student" do
      task = FactoryGirl.create(:task, common: true, grade: User::GRADES[2])
      student = FactoryGirl.create(:user, {roles: ["student"], grade: User::GRADES[2]})
      exercise_content = "I'm exercise"

      login student

      visit tasks_path

      within("#task-#{task.id}") { click_on I18n.t("helpers.enter") }

      fill_in_editor exercise_content
      submit_form

      assert_equal task_path(task), current_path
      assert_equal exercise_content, task.exercises.last.content

      click_on I18n.t("tasks.show.all_answers")
      assert page.has_content?(exercise_content)
    end

    should "high grade student could view low grade student's exercises" do
      task = FactoryGirl.create(:task, common: true, grade: User::GRADES[2])
      lower_grade_student = FactoryGirl.create(:user, {roles: ["student"], grade: User::GRADES[2]})
      higher_grade_student = FactoryGirl.create(:user, {roles: ["student"], grade: User::GRADES[3]})
      exercise_content = "I'm exercise"

      login lower_grade_student

      visit tasks_path

      within("#task-#{task.id}") { click_on I18n.t("helpers.enter") }

      click_on I18n.t("tasks.show.my_answer")
      fill_in_editor exercise_content
      submit_form

      logout
      login higher_grade_student

      visit tasks_path
      within("#task-#{task.id}") { click_on I18n.t("helpers.enter") }

      click_on I18n.t("tasks.show.all_answers")
      assert page.has_content?(exercise_content)
    end

    should "low grade student could NOT view high grade student's exercises" do
      task = FactoryGirl.create(:task, common: true, grade: User::GRADES[2])
      lower_grade_student = FactoryGirl.create(:user, {roles: ["student"], grade: User::GRADES[2]})
      higher_grade_student = FactoryGirl.create(:user, {roles: ["student"], grade: User::GRADES[3]})
      exercise_content = "I'm exercise"

      login higher_grade_student

      visit tasks_path

      within("#task-#{task.id}") { click_on I18n.t("helpers.enter") }
      click_on I18n.t("tasks.show.my_answer")
      fill_in_editor exercise_content
      submit_form

      logout
      login lower_grade_student

      visit tasks_path
      within("#task-#{task.id}") { click_on I18n.t("helpers.enter") }

      click_on I18n.t("tasks.show.all_answers")
      assert page.has_no_content?(exercise_content)
    end

    should "visible to mentor only exercise should be invisible to other student" do
      task = FactoryGirl.create(:task, common: true, grade: User::GRADES[2])
      lower_grade_student = FactoryGirl.create(:user, {roles: ["student"], grade: User::GRADES[2]})
      higher_grade_student = FactoryGirl.create(:user, {roles: ["student"], grade: User::GRADES[3]})
      exercise_content = "I'm exercise"

      login lower_grade_student

      visit tasks_path

      within("#task-#{task.id}") { click_on I18n.t("helpers.enter") }

      click_on I18n.t("tasks.show.my_answer")
      check "exercise[visible_to_mentor_only]"
      fill_in_editor exercise_content
      submit_form

      logout
      login higher_grade_student

      visit tasks_path
      within("#task-#{task.id}") { click_on I18n.t("helpers.enter") }

      click_on I18n.t("tasks.show.all_answers")
      assert page.has_no_content?(exercise_content)
    end
  end
end
