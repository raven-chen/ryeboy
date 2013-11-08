module ExercisesHelper
  def unsigned_tasks_at date
    Task.all - current_user.exercises.on_date(date).map{ |e| e.task }
  end

  def unfinished_exercises_detail users
    results = []
    users.each do |user, tasks|
      results << link_to(user.try(:name), "javascript:;", :class => "js-popover", "data-title" => "未完成功课", "data-content" => unfnished_task_list(tasks))
    end

    results.join(", ").html_safe
  end

  def unfnished_task_list tasks
    unfinished = []
    tasks.each do |task, stats|
      unfinished << task if !stats
    end

    unfinished.map(&:name).join(", ")
  end
end
