module CommentHelper
  # Generate resource show path. e.g. exercise_path(@exercise)
  def comment_source_path comment
    self.send("#{comment.commentable.class.name.underscore}_path", comment.commentable)
  end

  def actions_on_comment comment, user
    return if comment.author != user

    edit = link_to(I18n.t("helpers.edit"), edit_comment_path(comment))
    delete = link_to(I18n.t("helpers.delete"), comment, method: :delete, data: { confirm: I18n.t("helpers.are_you_sure") })
    content_tag(:div, [edit, delete].join(" ").html_safe, :class => "operations")
  end
end
