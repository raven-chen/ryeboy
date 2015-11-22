module ExercisesHelper
  def unsigned_tasks_at date
    current_user.my_tasks - current_user.exercises.on_date(date).map{ |e| e.task }
  end

  def separate_tasks_by_required tasks
    tasks.partition{ |task| task.required }
  end

  RATE_COUNT_DOWN = 48.hours

  def rate_count_down exercise
    time_passed_in_sec = (exercise.created_at + RATE_COUNT_DOWN - Time.now).abs

    if time_passed_in_sec > RATE_COUNT_DOWN.to_i
      [false, t("notices.over_count_down")]
    else
      [true, seconds2dhm(time_passed_in_sec)]
    end
  end

  # seconds(int) to Day Hour Minute
  def seconds2dhm seconds
    "%2d天 %02d小时 %02d分钟" % [seconds/86400, seconds/3600%24, seconds/60%60]
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

  def no_comment_search_button options
    active_class = "active" if options[:no_comment].present?
    content_tag(:button, "无人问津", :class => "btn #{active_class} js-no-comment-select btn-warning")
  end

  def like_widget user, exercise
    icon_class = user.liked_exercises.include?(exercise) ? "icon-heart hint-text liked" : "icon-heart-empty hint-text"
    icon = content_tag(:i, nil, :class => icon_class)
    counter = content_tag(:span, exercise.fan, :class => "counter liked-count")

    content_tag(:span, icon + counter + "人喜欢", :class => "js-like-exercise like-widget hint-text", "data-exercise-id" => exercise.id).html_safe
  end

  def comment_detail comment
    author_info = [content_tag(:span, comment.author.try(:name), class: "username")]
    author_info.concat [t('helpers.reply'), content_tag(:span, comment.replied_comment.author.try(:name), class: "username")] if comment.reply_to_comment?
    "#{author_info.join(" ")} : #{comment.content}".html_safe
  end

  def comment_place_holder comment
    if comment.reply_to_comment?
      "#{t('helpers.reply')} : #{comment.replied_comment.author.try(:name)}"
    else
      "新评论"
    end
  end

  # Display visible_to_admin_only exercise for admin only
  def visible_exercise? exercise
    !exercise.task.try(:visible_to_admin_only) || current_user.mentor?
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
