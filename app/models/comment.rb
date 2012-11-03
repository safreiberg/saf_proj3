# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  post_id    :integer
#  user_id    :integer
#  content    :text
#  parent     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  rank       :integer
#  downvotes  :integer
#  upvotes    :integer
#

class Comment < ActiveRecord::Base
  attr_accessible :content, :parent, :post_id, :user_id, :upvotes, :downvotes, :rank
  
  def user
    return User.find_by_id(self.user_id)
  end
  
  def decrement_upvotes
    self.upvotes = self.upvotes - 1
    self.rank = self.upvotes - self.downvotes
    self.save
    u = self.user
    u.decrement_comment_karma
  end
  
  def decrement_downvotes
    self.downvotes = self.downvotes - 1
    self.rank = self.upvotes - self.downvotes
    self.save
    u = self.user
    u.increment_comment_karma
  end
  
  def increment_upvotes
    self.upvotes = self.upvotes + 1
    self.rank = self.upvotes - self.downvotes
    self.save
    u = self.user
    u.increment_comment_karma
  end
  
  def increment_downvotes
    self.downvotes = self.downvotes + 1
    self.rank = self.upvotes - self.downvotes
    self.save
    u = self.user
    u.decrement_comment_karma
  end
end
