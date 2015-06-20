class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :name
      t.text :content
      t.integer :author_id
      t.string :category

      t.timestamps
    end
  end
end
