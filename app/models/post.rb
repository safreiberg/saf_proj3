# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  title      :string(255)
#  upvotes    :integer
#  downvotes  :integer
#  rank       :integer
#

class Post < ActiveRecord::Base
  attr_accessible :content, :user_id, :title, :upvotes, :downvotes, :rank
  
  def user
    return User.find_by_id(self.user_id)
  end
  
  def decrement_upvotes
    self.upvotes = self.upvotes - 1
    self.rank = self.upvotes - self.downvotes
    self.save
    u = self.user
    u.decrement_link_karma
  end
  
  def decrement_downvotes
    self.downvotes = self.downvotes - 1
    self.rank = self.upvotes - self.downvotes
    self.save
    u = self.user
    u.increment_link_karma
  end
  
  def increment_upvotes
    self.upvotes = self.upvotes + 1
    self.rank = self.upvotes - self.downvotes
    self.save
    u = self.user
    u.increment_link_karma
  end
  
  def increment_downvotes
    self.downvotes = self.downvotes + 1
    self.rank = self.upvotes - self.downvotes
    self.save
    u = self.user
    u.decrement_link_karma
  end
  
end
