module NotificationsHelper
  def notifications user, category
    return if user.blank?

    Notification.where(category: category).where("updated_at > ?", user.read_notification_at || Date.new(2000,1,1))
  end
end
