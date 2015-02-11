class ExercisesController < ApplicationController

  def review
    @month = params[:month]
  end

  def show
    @exercise = Exercise.find(params[:id])
  end

  def new
    @task = Task.find(params[:task_id])
    @exercise = Exercise.new(:date => (params[:date].try(:to_date) || Date.today), :task_id => @task.id, :user_id => current_user.id)
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
        @edit_existing_exercise = I18n.t("helpers.may_want_to_edit", :edit_exercise_url => edit_exercise_url(existing_exercise))
      end

      @task = @exercise.task

      respond_to do |format|
        format.html { render :new }
      end
    end
  end

  def edit
    @exercise = current_user.exercises.find(params[:id])
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
    @options = {}

    @options = %w{from to task_id user_id order}.inject({}.with_indifferent_access) { |m, key|
      params.delete(key) if params[key].blank? # Strip out blank string

      case key
      when "from"
        m[key] = params[key] || 1.day.ago.to_date
      when "to"
        m[key] = params[key] || Date.current
      else
        m[key] = params[key] if params[key].present?
      end

      m
    }

    @exercises = Exercise.scoped.includes(:comments, :task, :user)

    @exercises = @exercises.where(:date => @options[:from]..@options[:to])

    [:task_id, :user_id].each {|attr| @exercises = @exercises.where(attr => params[attr]) if params[attr].present? }

    @exercises = case @options[:order]
                   when "favorite"
                     @exercises.order("fan DESC, updated_at")
                   when "ask_for_comment"
                     @exercises.order("ask_for_comment DESC, updated_at")
                   else
                     @exercises.order("updated_at DESC")
                 end
  end

  def my
    if params[:task_id] or params[:date]
      @exercises = Exercise.scoped
      @date = params[:date]
      @task_id = params[:task_id]

      [:task_id, :date].each do |attr|
        @exercises = @exercises.where(attr => params[attr], :user_id => current_user.id) if params[attr].present?
      end

      @exercises = @exercises.order("date DESC")
    else
      @exercises = current_user.exercises
    end
  end

  def unfinished
    @start_date = params[:start_date] || Date.current
    @end_date = params[:end_date] || Date.current
    @task = Task.find_by_id(params[:task_id])

    @unfinished_user_list = Exercise.unfinished_user(@task, @start_date.to_date, @end_date.to_date) if @task
  end

  def like
    @exercise = Exercise.find(params[:id])

    if current_user.liked_exercises.exclude?(@exercise)
      current_user.liked_exercises << @exercise

      render :json => ""
    else
      render :json => "", :status => :unprocessable_entity
    end
  end

  def dislike
    @exercise = Exercise.find(params[:id])

    if current_user.liked_exercises.include?(@exercise)
      current_user.liked_exercises.delete @exercise

      render :json => ""
    else
      render :json => "", :status => :unprocessable_entity
    end
  end
end
