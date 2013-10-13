class CreateExercises < ActiveRecord::Migration
  def change
    create_table :exercises do |t|
      t.date :date
      t.text :content
      t.integer :task_id
      t.integer :user_id

      t.timestamps
    end
  end
end
