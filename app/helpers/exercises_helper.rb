module ExercisesHelper
  def unsigned_tasks_at date
    Task.all - current_user.exercises.on_date(date).map{ |e| e.task }
  end
end
