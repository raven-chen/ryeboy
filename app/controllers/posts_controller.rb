class PostsController < ApplicationController
  load_and_authorize_resource

  def index
    @posts = params[:category].present? ? Post.includes(:comments).where(category: params[:category]) : Post.includes(:comments).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  def show
    @post = Post.includes(:comments).find(params[:id])
    @comments = @post.comments.order("created_at DESC")
    @comment = Comment.new(commentable: @post)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  def create
    @post = Post.new(params[:post])
    @post.author = current_user

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: I18n.t("notices.create_%{obj}_successfully", :obj => @post.name) }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @post = current_user.posts.find(params[:id])
  end

  def update
    @post = current_user.posts.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: I18n.t("notices.update_%{obj}_successfully", :obj => @post.name) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy

    flash[:notice] = I18n.t("notices.delete_%{obj}_successfully", :obj => @post.name)

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end
end
