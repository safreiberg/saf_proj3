class PostVote < ActiveRecord::Base
  attr_accessible :post_id, :up, :user_id
end
