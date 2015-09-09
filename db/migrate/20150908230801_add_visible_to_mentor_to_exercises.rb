class AddVisibleToMentorToExercises < ActiveRecord::Migration
  def change
    add_column :exercises, :visible_to_mentor_only, :boolean, default: false
  end
end
