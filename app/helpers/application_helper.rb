module ApplicationHelper
  def received_comment_text
    unread_count = Comment.unread_count(current_user)
    text = unread_count > 0 ? "#{t("helpers.received_comment")} (#{content_tag(:span, unread_count, :class => "unread-count")})" : t("helpers.received_comment")
  end
end
