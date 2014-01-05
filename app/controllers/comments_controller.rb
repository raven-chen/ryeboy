class CommentsController < ApplicationController
  before_filter :find_comment, :only => [:edit, :update, :destroy]

  def index
    @comments = Comment.master_comments
  end

  def received
    @unread_comments = Comment.unread(current_user)
    @read_comments = Comment.received(current_user) - @unread_comments
  end

  def new
    exercise = Exercise.find(params[:exercise_id])
    @comment = exercise.comments.build
  end

  def create
    @comment = Comment.new(params[:comment])
    @comment.author = current_user

    if @comment.save
      flash[:notice]= I18n.t("notices.create_%{obj}_successfully", :obj => Comment.model_name.human)

      redirect_to exercises_path
    else
      flash[:alert]= I18n.t("notices.create_%{obj}_failed_%{errors}", :obj => Comment.model_name.human,
                            :errors => "<br> #{@comment.errors.messages.values.join}")

      respond_to do |format|
        format.html { render :new }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to exercises_path, notice: I18n.t("notices.update_%{obj}_successfully", :obj => Comment.model_name.human) }
      else
        flash[:alert]= I18n.t("notices.update_%{obj}_failed_%{errors}", :obj => Comment.model_name.human,
                      :errors => "<br> #{@comment.errors.messages.values.join}")

        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to exercises_path, notice: I18n.t("notices.delete_%{obj}_successfully", :obj => Comment.model_name.human) }
      format.json { head :no_content }
    end
  end

  def find_comment
    @comment = current_user.comments.find(params[:id])
  end
end
