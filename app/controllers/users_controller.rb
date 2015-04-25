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

  def assign_my_tasks
    tasks = Task.find(params[:task_ids])
    user = User.find(params[:id])

    user.my_tasks = tasks

    if user.save
      flash[:notice]= "操作成功"
    else
      flash[:alert]= "操作失败"
    end

    redirect_to root_path
  end

  def change_password
    @user = current_user
  end

  def update_password
    @user = current_user

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to root_path, notice: '密码已更新' }
      else
        format.html { render action: "change_password" }
      end
    end
  end
end
