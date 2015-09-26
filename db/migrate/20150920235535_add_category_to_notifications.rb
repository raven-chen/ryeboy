class AddCategoryToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :category, :string
    add_column :notifications, :grade, :string
    add_column :notifications, :name, :string

    add_column :users, :read_new_features_at, :datetime
    add_column :users, :read_new_notices_at, :datetime
  end
end
