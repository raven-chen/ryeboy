class AddVisibleToAdminOnlyToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :visible_to_admin_only, :boolean
  end
end
