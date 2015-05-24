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
end
