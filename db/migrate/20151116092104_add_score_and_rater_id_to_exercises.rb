class AddScoreAndRaterIdToExercises < ActiveRecord::Migration
  def change
    add_column :exercises, :rater_id, :integer
    add_column :exercises, :score, :integer
    add_column :exercises, :scored_at, :datetime
  end
end
