class AddAttributesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sno, :string
    add_column :users, :forum_id, :string
    add_column :users, :group_id, :integer
    add_column :users, :qq, :string
    add_column :users, :tel_number, :string
    add_column :users, :address, :string
    add_column :users, :birth_date, :date
    add_column :users, :note, :text
  end
end
