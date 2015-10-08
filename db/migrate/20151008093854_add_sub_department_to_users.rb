class AddSubDepartmentToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sub_department, :string
  end
end
