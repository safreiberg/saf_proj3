# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  password_digest :string(255)
#  admin           :boolean
#  username        :string(255)
#  link_karma      :integer
#  comment_karma   :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessible :admin, :email, :name, :password_digest, :password, :username, :password_confirmation, :link_karma, :comment_karma
  has_secure_password

  validates :password, :presence => true, :on => :create
  validates :email, :presence => true
  validates :email, :uniqueness => true
  validates :username, :presence => true
  validates :username, :uniqueness => true
  
  def increment_link_karma
    self.link_karma = self.link_karma + 1
    self.save
  end
  
  def decrement_link_karma
    self.link_karma = self.link_karma - 1
    self.save
  end
  
  def increment_comment_karma
    self.comment_karma = self.comment_karma + 1
    self.save
  end
  
  def decrement_comment_karma
    self.comment_karma = self.comment_karma - 1
    self.save
  end
  
  def total_karma
    return -(self.comment_karma + self.link_karma)
  end
  
  def link_karma_rank
    User.where("link_karma > ?", self.link_karma).count + 1
  end
  
  def comment_karma_rank
    User.where("comment_karma > ?", self.comment_karma).count + 1
  end
  
  def total_karma_rank
    users = User.find(:all).sort_by &:total_karma
    rank = 1
    users.each do |u|
      if u == self
        return rank
      end
      rank = rank + 1
    end
  end
end
