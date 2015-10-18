module ApplicationHelper
  def received_comment_text
    unread_count = Comment.unread_count(current_user)
    text = unread_count > 0 ? "#{t("helpers.received_comment")} (#{content_tag(:span, unread_count, :class => "unread-count")})" : t("helpers.received_comment")
  end

  def maybe_selected_class value, current_value, classes, selected_classes
    current_value == value ? selected_classes : classes
  end

  def brand_name
    Dir.pwd =~ /ryegirl/ ? "莲花伊人" : "麦田男孩"
  end

  # To use this method, the object must have author and support edit and delete actions
  def actions_on_object object, user, have_show_link = false
    operations = []

    operations << link_to(I18n.t("helpers.view"), object) if have_show_link

    if object.author == user
      operations << link_to(I18n.t("helpers.edit"), eval("edit_#{object.class.name.downcase}_path(object)"))
      operations << link_to(I18n.t("helpers.delete"), object, method: :delete, data: { confirm: I18n.t("helpers.are_you_sure") })
    end

    operations.join(" ").html_safe
  end

  def actions_on_object_no_author object
    operations = []

    operations << link_to(I18n.t("helpers.view"), object)
    operations << link_to(I18n.t("helpers.edit"), eval("edit_#{object.class.name.downcase}_path(object)"))
    operations << link_to(I18n.t("helpers.delete"), object, method: :delete, data: { confirm: I18n.t("helpers.are_you_sure") })

    content_tag(:div, operations.join(" ").html_safe, :class => "operations")
  end

  def controller?(*controller)
    controller.include?(params[:controller])
  end

  def action?(*action)
    action.include?(params[:action])
  end
end
