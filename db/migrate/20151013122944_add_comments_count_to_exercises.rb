class AddCommentsCountToExercises < ActiveRecord::Migration
  def change
    add_column :exercises, :comments_count, :integer, :default => 0

    Exercise.find_each do |e|
      e.update_attribute :comments_count, e.comments.count
    end
  end
end
