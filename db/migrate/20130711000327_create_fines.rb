class CreateFines < ActiveRecord::Migration
  def change
    create_table :fines do |t|
      t.integer :amount
      t.date :date
      t.string :reason
      t.boolean :paid
      t.text :comment
      t.integer :user_id

      t.timestamps
    end
  end
end
