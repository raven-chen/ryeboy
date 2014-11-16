class AddSelfJoinToComment < ActiveRecord::Migration
  def change
    add_column :comments, :replied_comment_id, :integer
  end
end
