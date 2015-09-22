class AddCategoryToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :category, :string
    add_column :notifications, :grade, :string
  end
end
