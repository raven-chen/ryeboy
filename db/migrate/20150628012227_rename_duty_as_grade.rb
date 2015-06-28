class RenameDutyAsGrade < ActiveRecord::Migration
  def change
    rename_column :users, :duty, :grade
    rename_column :users, :level, :department
  end
end
