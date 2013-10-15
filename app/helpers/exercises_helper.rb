module ExercisesHelper
  def unsigned_tasks_today
    Task.all - current_user.exercises.on_date(Date.today).map{ |e| e.task }
  end
end
