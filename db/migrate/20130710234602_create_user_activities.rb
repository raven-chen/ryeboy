class CreateUserActivities < ActiveRecord::Migration
  def change
    create_table :user_activities do |t|
      t.text :note
      t.boolean :sign_in
      t.boolean :ask_for_leave
      t.integer :user_id

      t.timestamps
    end
  end
end
