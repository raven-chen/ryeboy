class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.text :content
      t.boolean :active

      t.timestamps
    end
  end
end
