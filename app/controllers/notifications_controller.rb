class NotificationsController < ApplicationController
  load_and_authorize_resource

  def index
    @notifications = Notification.active
  end

  def show
    @notification = Notification.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @notification }
    end
  end

  def new
    @notification = Notification.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @notification }
    end
  end

  def create
    @notification = Notification.new(params[:notification])
    @notification.active = true

    respond_to do |format|
      if @notification.save
        format.html { redirect_to @notification, notice: I18n.t("notices.create_%{obj}_successfully", :obj => @notification.name) }
        format.json { render json: @notification, status: :created, location: @notification }
      else
        format.html { render action: "new" }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @notification = Notification.find(params[:id])
  end

  def update
    @notification = Notification.find(params[:id])

    respond_to do |format|
      if @notification.update_attributes(params[:notification])
        format.html { redirect_to @notification, notice: I18n.t("notices.update_%{obj}_successfully", :obj => @notification.name) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @notification = Notification.find(params[:id])
    @notification.active = false

    if @notification.save
      flash[:notice] = I18n.t("notices.delete_%{obj}_successfully", :obj => @notification.name)
    else
      flash[:error] = "出现错误"
    end

    respond_to do |format|
      format.html { redirect_to notifications_url }
      format.json { head :no_content }
    end
  end
end
