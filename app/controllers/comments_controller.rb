class CommentsController < ApplicationController
  def new
    exercise = Exercise.find(params[:exercise_id])
    @comment = exercise.comments.build
  end

  def create
    @comment = Comment.new(params[:comment])
    @comment.author = current_user

    if @comment.save
      flash[:notice]= I18n.t("notices.create_%{object}_successfully", :object => Comment.model_name.human)

      redirect_to exercises_path
    else
      flash[:alert]= I18n.t("notices.create_%{object}_failed_%{errors}", :object => Comment.model_name.human,
                            :errors => "<br> #{@comment.errors.messages.values.join}")

      respond_to do |format|
        format.html { render :new }
      end
    end
  end
end
