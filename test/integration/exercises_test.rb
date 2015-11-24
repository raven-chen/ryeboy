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

    visit exercises_path

    page.find(:css, ".write-exercise").click
    page.find(:css, "div.active .task-#{@task.id}").click

    fill_in_editor "test"

    click_button I18n.t("helpers.submit")
    sleep 1

    assert @mentor.exercises.present?
    assert_equal "test", @mentor.exercises.last.content
    assert_equal Date.current, @mentor.exercises.last.date
  end

  context "rate exercise" do
    setup do
      @student = FactoryGirl.create(:user)
      @student.roles = ["student"]
      @student.save!
    end

    context "for mentor" do
      should "be able to see rate selector and rate it for exercise created less than 48 hours" do
        exercise = FactoryGirl.create(:exercise, :task => @task, :user => @student)

        login @mentor

        visit exercises_path

        within("li.item-container#exercise-#{exercise.id}") do
          score = 1
          select(score, from: "score")

          sleep 1
          assert_equal I18n.t("notices.exercise_get_%{score}", score: score), find(".exercise-rating").text

          exercise.reload
          assert_equal score, exercise.score
          assert_equal @mentor, exercise.rater
          assert exercise.scored_at
        end
      end

      should "cannot see rate selector for exercise created more than 48 hours" do
        exercise = FactoryGirl.create(:exercise, :task => @task, :user => @student, created_at: 3.days.ago)

        login @mentor

        visit exercises_path

        within("li.item-container#exercise-#{exercise.id}") do
          assert_equal I18n.t("notices.over_count_down"), find(".exercise-rating").text
          page.has_no_selector?(".js-rate-exercise")
        end
      end
    end

    context "for student" do
      should "see 'no score' notice for exercise created less than 48 hours" do
        exercise = FactoryGirl.create(:exercise, :task => @task, :user => @student)

        login @student

        visit exercises_path

        within("li.item-container#exercise-#{exercise.id}") do
          assert_equal I18n.t("notices.not_scored"), find(".exercise-rating").text
          page.has_no_selector?(".js-rate-exercise")
        end
      end

      should "see notice for exercise created more than 48 hours" do
        exercise = FactoryGirl.create(:exercise, :task => @task, :user => @student, created_at: 3.days.ago)

        login @student

        visit exercises_path

        within("li.item-container#exercise-#{exercise.id}") do
          assert_equal I18n.t("notices.not_scored"), find(".exercise-rating").text
          page.has_no_selector?(".js-rate-exercise")
        end
      end
    end
  end
end
