class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  def profile
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def add_to_my_tasks
    task = Task.find(params[:id])
    current_user.tasks << task

    if current_user.save
      flash[:notice]= "已添加"
    else
      flash[:alert]= "添加出现错误"
    end

    redirect_to root_path
  end
end
