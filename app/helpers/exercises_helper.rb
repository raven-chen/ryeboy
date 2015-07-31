module ExercisesHelper
  def unsigned_tasks_at date
    current_user.my_tasks - current_user.exercises.on_date(date).map{ |e| e.task }
  end

  def separate_tasks_by_required tasks
    tasks.partition{ |task| task.required }
  end

  def unfinished_title
    "#{@start_date} - #{@end_date} #{@task.name}" if @unfinished_user_list
  end

  def quick_date_select_buttons options
    result = [
      ["最近一天", 1.day.ago.to_date],
      ["最近三天", 3.days.ago.to_date]
    ].map do |item|
      active_class = options[:from].try(:to_date) == item[1] ? "btn-default active" : "btn-default"
      content_tag(:button, item[0], :class => "btn #{active_class} js-quick-date-select", "data-from" => item[1], "data-to" => Date.current)
    end

    result.join(" ").html_safe
  end

  def order_buttons options
    result = [
      ["最受欢迎", "favorite", "btn-info"],
      ["求点评!", "ask_for_comment", "btn-success"]
    ].map do |item|
      active_class = "active" if options[:order] == item[1]
      content_tag(:button, item[0], :class => "btn #{active_class} js-order-select #{item[2]}", "data-order" => item[1])
    end

    result.join(" ").html_safe
  end

  def like_widget user, exercise
    icon_class = user.liked_exercises.include?(exercise) ? "icon-heart hint-text liked" : "icon-heart-empty hint-text"
    icon = content_tag(:i, nil, :class => icon_class)
    counter = content_tag(:span, exercise.fan, :class => "counter liked-count")

    content_tag(:span, icon + counter + "人喜欢", :class => "js-like-exercise like-widget hint-text", "data-exercise-id" => exercise.id).html_safe
  end

  def comment_detail comment
    author_info = [content_tag(:span, comment.author.name, class: "username")]
    author_info.concat [t('helpers.reply'), content_tag(:span, comment.replied_comment.author.name, class: "username")] if comment.reply_to_comment?
    "#{author_info.join(" ")} : #{comment.content}".html_safe
  end

  def comment_place_holder comment
    if comment.reply_to_comment?
      "#{t('helpers.reply')} : #{comment.replied_comment.author.name}"
    else
      "新评论"
    end
  end

  def visible_exercises task
    task.exercises
  end

  # Display visible_to_admin_only exercise for admin only
  def visible_exercise? exercise
    !exercise.task.visible_to_admin_only || current_user.mentor?
  end

  def exercises_from_each_month user
    result = {}

    (1..12).each do |i|
      date = Date.new(2014,i,1)
      start = date.beginning_of_month
      end_date = date.end_of_month

      sample_exercise = exercises_of_month(user, i).try(:last)
      result[i]= sample_exercise if sample_exercise.present?
    end

    result
  end

  def exercises_of_month user, month
    date = Date.new(2014, month.to_i, 1)
    start = date.beginning_of_month
    end_date = date.end_of_month

    user.exercises.where(:date => start..end_date).reverse
  end
end
