class UsersController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => [:profile, :change_password, :update_password, :assign_my_tasks]

  def index
    @options = {}
    @options = %w{name tag role}.inject({}.with_indifferent_access) { |m, key|
      params.delete(key) if params[key].blank? # Strip out blank string

      m[key] = params[key]

      m
    }

    @users = current_user.admin? ? User.scoped : User.visible

    @users = @users.where("name LIKE ?", "%#{@options[:name]}%") if @options[:name]

    @users = @users.tagged_with(params[:tag]) if @options[:tag]

    @users = @users.with_role(@options[:role]) if @options[:role]

    @users = @users.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
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
    @topics = Topic.recent_five

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


  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to users_path, notice: '用户已更新' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def new_tag
    @target_user = User.find(params[:id])
    @tag_type = params[:tag_type]

    render "tagging"
  end

  def add_tag
    if (current_user.hr? || current_user.id.to_s == params[:id]) && User::TAG_TYPES.include?(params[:tag_type])
      @target_user = User.find(params[:id])
      @target_user.send("#{params[:tag_type]}_list=", params[:tags])

      if @target_user.save
        flash[:notice]= "标签已添加"
        redirect_to users_path
      else
        redirect_to users_path, status: :unprocessible_entity
      end
    else
      redirect_to users_path, status: :bad_request
    end
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

  def reset_password
    @user = User.find(params[:id])
    @user.password = User::DEFAULT_PASSWORD

    if @user.save
      notice = "密码重置成功"
    else
      notice = "密码重置失败 #{@user.errors.inspect}"
    end

    respond_to do |format|
      format.html {
        redirect_to users_path, notice: notice
      }
    end
  end
end
