module NotificationsHelper
  def notifications user, category
    return if user.blank?

    Notification.applicable(user.grade).unread(user.read_notification_at).where(category: category)
  end
end
