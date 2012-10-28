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
#

class Post < ActiveRecord::Base
  attr_accessible :content, :user_id, :title, :upvotes, :downvotes, :rank
  
  def decrement_upvotes
    self.upvotes = self.upvotes - 1
    self.rank = self.upvotes - self.downvotes
    self.save
  end
  
  def decrement_downvotes
    self.downvotes = self.downvotes - 1
    self.rank = self.upvotes - self.downvotes
    self.save
  end
  
  def increment_upvotes
    self.upvotes = self.upvotes + 1
    self.rank = self.upvotes - self.downvotes
    self.save
  end
  
  def increment_downvotes
    self.downvotes = self.downvotes + 1
    self.rank = self.upvotes - self.downvotes
    self.save
  end
  
end
