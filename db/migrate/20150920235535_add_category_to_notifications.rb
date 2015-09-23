class AddCategoryToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :category, :string
    add_column :notifications, :grade, :string
    add_column :notifications, :name, :string
  end
end
