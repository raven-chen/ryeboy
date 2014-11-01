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
      ["最近一周", 1.weeks.ago.to_date]
    ].map do |item|
      active_class = options[:from].try(:to_date) == item[1] ? "btn-default active" : "btn-default"
      content_tag(:button, item[0], :class => "btn #{active_class} js-quick-date-select", "data-from" => item[1], "data-to" => Date.current)
    end

    result.join(" ").html_safe
  end
end
