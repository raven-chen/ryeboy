class CommentsController < ApplicationController
  before_filter :find_comment, :only => [:edit, :update, :destroy]

  def index
    @unread_comments = Comment.unread(current_user)

    @read_comments = Comment.received(current_user) - @unread_comments

    # Filter out delete user's comments
    @unread_comments.select!{|c| c.valid?}
    @read_comments.select!{|c| c.valid?}

    @unread_comments.update_all(:read_at => Time.now)
  end

  def new
    resource_name = params[:resource_name]

    if resource_name.blank? || !Kernel.const_defined?(resource_name.titleize)
      redirect_to home_path, status: :unprocessable_entity, alert: "错误的请求"
      return
    end

    resource = resource_name.classify.constantize.find(params[:resource_id])
    @comment = resource.comments.build(replied_comment_id: params[:replied_comment_id])
  end

  def create
    @comment = Comment.new(params[:comment])
    @comment.author = current_user

    unless @comment.save
      @notice = I18n.t("notices.create_%{obj}_failed_%{errors}", :obj => Comment.model_name.human,
            :errors => "<br> #{@comment.errors.messages.values.join}")
    end

    respond_to do |format|
      format.html {
        redirect_path = "#{@comment.commentable.class.table_name.singularize}_path"
        redirect_to send(redirect_path, @comment.commentable)
      }
      format.js { render :create, status: :created }
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        commentable_show_path = eval("#{@comment.commentable.class.table_name.singularize}_path(:id => #{@comment.commentable.id})")
        format.html { redirect_to commentable_show_path, notice: I18n.t("notices.update_%{obj}_successfully", :obj => Comment.model_name.human) }
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
      format.html { redirect_to home_path, notice: I18n.t("notices.delete_%{obj}_successfully", :obj => Comment.model_name.human) }
      format.json { head :no_content }
    end
  end

  def find_comment
    @comment = current_user.comments.find(params[:id])
  end
end
