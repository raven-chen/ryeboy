class RemoveRailsAdmin < ActiveRecord::Migration
  def change
    drop_table :rails_admin_histories
    drop_table :rich_rich_files
  end
end
