class Leancloud::UsersController < ApplicationController
  load_and_authorize_resource :lc_user

  def index
    @options = {}
    @options = %w{email}.inject({}.with_indifferent_access) { |m, key|
      params.delete(key) if params[key].blank? # Strip out blank string

      m[key] = params[key]

      m
    }

    @users = if @options[:email]
               LcUser.where(email: @options[:email])
             else
               LcUser.order("updated_at DESC").limit(25)
             end
  end

  def edit
    @user = LcUser.find(params[:id])
  end

  def update
    @user = LcUser.find(params[:id])

    if @user.update_attributes(user_params)
      flash[:notice] = "更新成功"
      redirect_to leancloud_users_path
    else
      flash[:error] = "更新失败"
      render :edit
    end
  end

  def reset_password
    user = LcUser.find(params[:id])

    user.password = User::DEFAULT_PASSWORD

    if user.save
      flash[:notice] = "密码重置成功"
    else
      flash[:error] = "密码重置失败"
    end

    redirect_to leancloud_users_path
  end

  private
  def user_params
    params.require(:lc_user).permit(:username, :email, :level)
  end
end
