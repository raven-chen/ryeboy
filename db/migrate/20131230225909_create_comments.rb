class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :author_id
      t.integer :exercise_id
      t.text :content

      t.timestamps
    end
  end
end
