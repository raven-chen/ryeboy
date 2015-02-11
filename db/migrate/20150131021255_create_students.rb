class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :name
      t.string :gender
      t.integer :age
      t.string :qq
      t.string :career
      t.boolean :marriage
      t.string :phone_number
      t.string :address
      t.string :group
      t.string :level
      t.text :comment
      t.string :exercise_url

      t.timestamps
    end
  end
end
