class UserActivitiesController < ApplicationController
  # GET /user_activities
  # GET /user_activities.json
  def index
    @user_activities = UserActivity.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_activities }
    end
  end

  # GET /user_activities/1
  # GET /user_activities/1.json
  def show
    @user_activity = UserActivity.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user_activity }
    end
  end
end
