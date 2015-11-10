module UsersHelper
  def add_tag_links user
    return unless current_user.hr? || current_user == user

    User::TAG_TYPES.map do |tag_type|
      link_to("添加#{tag_type_map[tag_type]}", new_tag_user_path(user, tag_type: tag_type))
    end.join(" ").html_safe
  end

  def tag_type_map
    {"skill" => "技能倾向", "hobby" => "关注倾向", "personality" => "性格倾向"}
  end

  def user_type user
    User::ROLES_MAP.each do |role, name|
      if user.send("#{role}?")
        return name
      end
    end
  end

  def self_study_notice user
    # TODO: move this to site configuration
    content_tag(:div, link_to("自学流程", "http://bbs.ryeboy.org/topics/133", :class => "btn btn-success btn-large", :target => "_blank"), :class => "self-study alert alert-warning") if user.blank? || user.newbie?
  end

  def author_info object
    content_tag(:span, "#{object.author.name} 创建于 #{I18n.l(object.created_at)}", :class => "hint-text author-info")
  end

  def link_to_user_exercises user
    link_to(user.name, exercises_path(user_id: user.id), {target: "_blank"})
  end
end
