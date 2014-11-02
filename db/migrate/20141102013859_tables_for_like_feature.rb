class TablesForLikeFeature < ActiveRecord::Migration
  def change
    create_table :interests do |t|
      t.integer :user_id
      t.integer :exercise_id

      t.timestamps
    end

    add_index :interests, [:user_id, :exercise_id], :unique => true

    # Record fans count in exercises to speed up query
    add_column :exercises, :fan, :integer, :default => 0
  end
end
