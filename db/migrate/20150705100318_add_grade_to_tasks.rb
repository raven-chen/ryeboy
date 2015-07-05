class AddGradeToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :grade, :string
  end
end
