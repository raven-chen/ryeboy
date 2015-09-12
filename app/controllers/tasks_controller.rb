class TasksController < ApplicationController
  load_and_authorize_resource

  # Actions in this controller are for common task ONLY

  def index
    @tasks = Task.common
  end

  def show
    @task = Task.common.find(params[:id])

    @my_exercise = if @task.finished_by?(current_user)
                     Exercise.where(:user_id => current_user.id, :task_id => @task.id).first
                   else
                     Exercise.new(:date => Date.current, :task_id => @task.id, :user_id => current_user.id)
                   end

    @all_exercises = @task.exercises.joins(:user).where("users.grade IN (?)", current_user.visible_grades)
  end

  def new
    @task = Task.new
  end

  def edit
    @task = Task.common.find(params[:id])
  end

  def create
    @task = Task.new(params[:task])
    @task.common = true # only common task is allowed to be created by front-end

    respond_to do |format|
      if @task.save
        format.html { redirect_to tasks_path, notice: I18n.t("notices.create_%{obj}_successfully", :obj => @task.name) }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @task = Task.find(params[:id])

    respond_to do |format|
      @task.common = true
      if @task.update_attributes(params[:task])
        format.html { redirect_to tasks_path, notice: I18n.t("notices.update_%{obj}_successfully", :obj => @task.name) }
      else
        format.html { render action: "edit" }
      end
    end
  end
end
