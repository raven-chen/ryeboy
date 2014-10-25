class AddRequiredToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :required, :boolean
  end
end
