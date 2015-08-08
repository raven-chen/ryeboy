class PostsController < ApplicationController
  load_and_authorize_resource

  def index
    @posts = params[:category].present? ? Post.where(category: params[:category]) : Post.all

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
end
