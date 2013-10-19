class ExercisesController < ApplicationController
  def new
    # TODO: validate task_id
    @task = Task.find(params[:task_id])
    @exercise = Exercise.new(:date => Date.today, :task_id => @task.id)
  end

  def create
    @exercise = Exercise.new(params[:exercise].merge(:user_id => current_user.id))

    if @exercise.save
      flash[:notice]= "#{@exercise.task.name} 打卡完成"

      redirect_to root_path
    else
      flash[:alert]= "#{@exercise.task.try(:name)} 打卡失败"

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
    @keyword = params[:keyword]

    @exercises = if @keyword.present?
                   @user = User.find_by_name(@keyword)
                   @user = User.find_by_sno(@keyword) unless @user.present?
                   @user.try(:excercises)
                 else
                   Exercise.newest
                 end
  end

  def my

  end
end
