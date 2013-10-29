class ExercisesController < ApplicationController
  def new
    @task = Task.find(params[:task_id])
    @exercise = Exercise.new(:date => Date.today, :task_id => @task.id, :user_id => current_user.id)
    @exercise.copy_content_from_previous_one
  end

  def create
    @exercise = Exercise.new(params[:exercise].merge(:user_id => current_user.id))

    if @exercise.save
      flash[:notice]= "#{@exercise.task.name} 打卡完成"

      redirect_to root_path
    else
      flash[:alert]= "#{@exercise.task.try(:name)} 打卡失败. <br> #{@exercise.errors.messages.values.join}"

      if @exercise.errors.messages.keys.include?(:date) && @exercise.date.present?
        existing_exercise = Exercise.where(:date => @exercise.date, :task_id => @exercise.task_id, :user_id => @exercise.user_id).first
        @edit_existing_exercise = I18n.t("helpers.may_want_to_edit", :edit_exercise_link => edit_exercise_url(existing_exercise))
      end

      @task = @exercise.task

      respond_to do |format|
        format.html { render :new }
      end
    end
  end

  def edit
    @exercise = Exercise.find(params[:id])
    @task = @exercise.task
  end

  def update
    @exercise = Exercise.find(params[:id])

    respond_to do |format|
      if @exercise.update_attributes(params[:exercise])
        format.html { redirect_to root_path, notice: '打卡已更新' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def index
    if params[:task_id].blank? && params[:date].blank? && params[:user_id].blank?
      @exercises = Exercise.newest
    else
      @exercises = Exercise.scoped
      @date = params[:date]
      @task_id = params[:task_id]
      @user_id = params[:user_id]

      [:task_id, :date, :user_id].each do |attr|
        @exercises = @exercises.where(attr => params[attr]) if params[attr].present?
      end

      @exercises = @exercises.order("date DESC")
    end
  end

  def my

  end
end
