class AddCommentsCountToExercises < ActiveRecord::Migration
  def change
    add_column :exercises, :comments_count, :integer, :default => 0

    Exercise.find_each do |e|
      e.touch
    end
  end
end
