class TasksController < ApplicationController
  load_and_authorize_resource

  def index
    @tasks = Task.common.where(grade: current_user.visible_grades)
  end

  def manage
    @tasks = Task.all
  end

  def show
    @task = Task.common.find(params[:id])

    @my_exercise = if @task.finished_by?(current_user)
                     Exercise.where(:user_id => current_user.id, :task_id => @task.id).first
                   else
                     Exercise.new(:date => Date.current, :task_id => @task.id, :user_id => current_user.id)
                   end

    @all_exercises = @task.exercises.joins(:user).where("users.grade IN (?)", current_user.visible_grades).visible_to(current_user)
  end

  def new
    @task = Task.new
  end

  def edit
    @task = Task.find(params[:id])
  end

  def create
    @task = Task.new(params[:task])

    respond_to do |format|
      if @task.save
        format.html { redirect_to manage_tasks_path, notice: I18n.t("notices.create_%{obj}_successfully", :obj => @task.name) }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @task = Task.find(params[:id])

    respond_to do |format|
      if @task.update_attributes(params[:task])
        format.html { redirect_to manage_tasks_path, notice: I18n.t("notices.update_%{obj}_successfully", :obj => @task.name) }
      else
        format.html { render action: "edit" }
      end
    end
  end
end
