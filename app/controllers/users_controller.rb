class UsersController < ApplicationController
  def index
    @options = {}
    @options = %w{name tag}.inject({}.with_indifferent_access) { |m, key|
      params.delete(key) if params[key].blank? # Strip out blank string

      m[key] = params[key]

      m
    }

    if @options[:name]
      @users = User.visible.where("name LIKE ?", "%#{@options[:name]}%")
    elsif @options[:tag]
      @users = User.visible.tagged_with(params[:tag])
    else
      @users = User.visible
    end

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
end
