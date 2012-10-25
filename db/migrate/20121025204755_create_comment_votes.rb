class CreateCommentVotes < ActiveRecord::Migration
  def change
    create_table :comment_votes do |t|
      t.integer :comment_id
      t.integer :user_id
      t.boolean :up

      t.timestamps
    end
  end
end
