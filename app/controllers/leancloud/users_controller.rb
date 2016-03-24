class Leancloud::UsersController < ApplicationController
  load_and_authorize_resource :lc_user

  def index
    @options = {}
    @options = %w{email}.inject({}.with_indifferent_access) { |m, key|
      params.delete(key) if params[key].blank? # Strip out blank string

      m[key] = params[key]

      m
    }

    users = AV::Query.new("_User").tap do |u|
              if @options[:email]
                u.eq("email", @options[:email])
              else
                u.limit = 25
              end
            end.get

    @users = users.map{|u| LcUser.new(objectId: u["objectId"], email: u["email"], username: u["username"], level: u["level"])}
  end

  def edit
    user = AV::Query.new("_User").eq("objectId", params[:objectId]).get.first
    @user = LcUser.new(objectId: user["objectId"], email: user["email"], username: user["username"], level: user["level"])
  end

  def update
    user = AV::Query.new("_User").eq("objectId", params[:objectId]).get.first
    lc_user = params["lc_user"]
    user["username"] = lc_user[:username]
    user["email"] = lc_user[:email]
    user["level"] = lc_user[:level]

    if user.save
      flash[:notice] = "更新成功"
      redirect_to leancloud_users_path
    else
      flash[:error] = "更新失败"
      render :edit
    end
  end

  def reset_password
    user = AV::Query.new("_User").eq("objectId", params[:objectId]).get.first

    user["password"] = User::DEFAULT_PASSWORD

    if user.save
      flash[:notice] = "密码重置成功"
    else
      flash[:error] = "密码重置失败"
    end

    redirect_to leancloud_users_path
  end
end
