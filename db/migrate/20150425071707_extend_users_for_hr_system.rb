class ExtendUsersForHrSystem < ActiveRecord::Migration
  def change
    add_column :users, :duty, :string
    add_column :users, :real_name, :string
    add_column :users, :gender, :string
    add_column :users, :education_experience, :text
    add_column :users, :work_experience, :text
    add_column :users, :favorite, :text
    add_column :users, :available_time, :string
  end
end
