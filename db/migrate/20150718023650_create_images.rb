class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.attachment :attachment
      t.timestamps
    end
  end
end
