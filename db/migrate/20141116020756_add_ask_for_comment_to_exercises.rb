class AddAskForCommentToExercises < ActiveRecord::Migration
  def change
    add_column :exercises, :ask_for_comment, :boolean
  end
end
