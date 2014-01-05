class AddReadAtAndUserIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :read_at, :datetime
    add_column :comments, :user_id, :integer

    add_index :comments, :user_id
    add_index :comments, :author_id
    add_index :comments, :exercise_id

    Comment.all.each{ |c|
      exercise = c.exercise
      c.user_id = exercise.user_id
      c.save!
    }
  end
end
