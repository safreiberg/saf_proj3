class AddRankToComments < ActiveRecord::Migration
  def change
    add_column :comments, :rank, :integer
  end
end
