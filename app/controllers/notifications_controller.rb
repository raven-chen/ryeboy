class NotificationsController < ApplicationController
  load_and_authorize_resource

  def index
    @notifications = Notification.all
  end
end
