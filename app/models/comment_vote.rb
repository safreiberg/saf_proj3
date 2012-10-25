class CommentVote < ActiveRecord::Base
  attr_accessible :comment_id, :up, :user_id
end
