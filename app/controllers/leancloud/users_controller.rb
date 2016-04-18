class Leancloud::UsersController < ApplicationController
  load_and_authorize_resource :lc_user

  def index
    @options = {}
    @options = %w{email username nickname}.inject({}.with_indifferent_access) { |m, key|
      params.delete(key) if params[key].blank? # Strip out blank string

      m[key] = params[key]

      m
    }

    @users = LcUser.order("updated_at DESC")

    @users = @users.where(email: @options[:email]) if @options[:email]
    @users = @users.where(username: /#{@options[:username]}/) if @options[:username]
    @users = @users.where(nickname: /#{@options[:nickname]}/) if @options[:nickname]

    @users = @users.limit(25)
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

    user.generate_encrypted_default_password

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
