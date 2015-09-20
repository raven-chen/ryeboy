class RemoveRepliesTable < ActiveRecord::Migration
  def change
    drop_table :replies
  end
end
