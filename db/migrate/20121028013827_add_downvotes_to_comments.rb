class AddDownvotesToComments < ActiveRecord::Migration
  def change
    add_column :comments, :downvotes, :integer
  end
end
