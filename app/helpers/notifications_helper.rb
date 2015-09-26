module NotificationsHelper
  def new_features user
    return if user.blank?

    Notification.applicable(user.grade).unread(user.read_new_features_at).where(category: Notification::CATEGORIES[0])
  end

  def new_notices user
    return if user.blank?

    Notification.applicable(user.grade).unread(user.read_new_notices_at).where(category: Notification::CATEGORIES[1])
  end
end
