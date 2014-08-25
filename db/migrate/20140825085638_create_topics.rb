class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :title
      t.text :content
      t.integer :author_id

      t.timestamps
    end
  end
end
