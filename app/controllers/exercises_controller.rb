class ExercisesController < ApplicationController
  load_and_authorize_resource except: [:index]
  skip_before_filter :authenticate_user!, only: [:index]

  def review
    @month = params[:month]
  end

  def show
    @exercise = Exercise.visible_to(current_user).find(params[:id])
  end

  def new
    @task = Task.find(params[:task_id])
    @exercise = Exercise.new(:date => (params[:date].try(:to_date) || Date.today), :task_id => @task.id, :user_id => current_user.id)
    @exercise.copy_template_from_task
  end

  def create
    @exercise = Exercise.new(params[:exercise].merge(:user_id => current_user.id))

    if @exercise.save
      flash[:notice]= "#{@exercise.read_task(:name)} 完成"

      if @exercise.read_task(:common?, true)
        redirect_to task_path(@exercise.task)
      else
        redirect_to exercises_path
      end
    else
      flash[:alert]= "#{@exercise.read_task(:name)} 日记失败. <br> #{@exercise.errors.messages.values.join}"

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
    @exercise = current_user.exercises.find(params[:id])
    @task = @exercise.task
  end

  def update
    @exercise = Exercise.find(params[:id])

    respond_to do |format|
      if @exercise.update_attributes(params[:exercise])
        format.html {
          flash[:notice]= "已更新"

          if @exercise.read_task(:common?, true)
            redirect_to task_path(@exercise.task)
          else
            redirect_to exercises_path
          end
        }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def index
    @options = {}

    @options = %w{from to task_id user_id order grade no_comment no_score}.inject({}.with_indifferent_access) { |m, key|
      params.delete(key) if params[key].blank? # Strip out blank string

      case key
      when "from"
        m[key] = params[key] || 3.days.ago.to_date
      when "to"
        m[key] = params[key] || Date.current
      else
        m[key] = params[key] if params[key].present?
      end

      m
    }

    @exercises = Exercise.visible_to(current_user).includes(:comments, :task, :user)

    @exercises = @exercises.joins(:user).where(users: { grade: @options[:grade] }) if @options[:grade]

    @exercises = @exercises.where(:date => @options[:from]..@options[:to])

    [:task_id, :user_id].each {|attr| @exercises = @exercises.where(attr => params[attr]) if params[attr].present? }

    @exercises = @exercises.no_comment if @options[:no_comment]

    @exercises = @exercises.no_score if @options[:no_score]

    @exercises = case @options[:order]
                   when "favorite"
                     @exercises.order("exercises.fan DESC, exercises.updated_at")
                   when "ask_for_comment"
                     @exercises.order("exercises.ask_for_comment DESC, exercises.updated_at")
                   else
                     @exercises.order("exercises.updated_at DESC")
                 end

    @exercises = @exercises.page(params[:page])
  end

  def my
    if params[:task_id] or params[:date]
      @exercises = Exercise.all
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
    @start_date = params[:start_date].try(:to_date) || Date.current
    @end_date = params[:end_date].try(:to_date) || Date.current
    @tasks = Task.where(id: params[:task_ids])
    @grade = params[:grade]

    @unfinished_user_list = Exercise.unfinished_user(@grade, @tasks, @start_date.to_date, @end_date.to_date) if @tasks
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

  def rate
    @exercise = Exercise.find(params[:id])
    @exercise.score = params[:score]
    @exercise.rater = current_user
    @exercise.scored_at = Time.now

    respond_to do |format|
      if @exercise.save
        format.json { render json: I18n.t("notices.exercise_get_%{score}_by_%{rater}", score: @exercise.score, rater: current_user.name).to_json }
      else
        format.json { render status: :unprocessable_entity }
      end
    end
  end
end
