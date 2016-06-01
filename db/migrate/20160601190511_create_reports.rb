class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.date :date
      t.integer :login_count

      t.timestamps
    end
  end
end
