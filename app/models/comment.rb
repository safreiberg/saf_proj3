class Comment < ActiveRecord::Base
  attr_accessible :content, :parent, :post_id, :user_id
end
