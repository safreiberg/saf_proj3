class AddDownvotesToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :downvotes, :integer
  end
end
