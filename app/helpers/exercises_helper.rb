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
end
