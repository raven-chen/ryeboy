class CreateHomepages < ActiveRecord::Migration
  def change
    create_table :homepage_items do |t|
      t.string :name
      t.string :category
      t.string :url
      t.integer :sequence
      t.boolean :view_more, default: false

      t.timestamps null: false
    end
  end
end
