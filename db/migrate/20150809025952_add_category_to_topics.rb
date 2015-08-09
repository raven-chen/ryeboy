class AddCategoryToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :category, :string
  end
end
