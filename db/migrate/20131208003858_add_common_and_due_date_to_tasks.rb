class AddCommonAndDueDateToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :common, :boolean
    add_column :tasks, :due_date, :date
  end
end
