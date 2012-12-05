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
  
  has_many :comments
  has_many :posts

  validates :password, :presence => true, :on => :create
  validates :email, :presence => true
  validates :email, :uniqueness => true
  validates :username, :presence => true
  validates :username, :uniqueness => true
  
  ## Processes the effects of a vote being posted to the author
  ## of a comment.
  def commentvote(up)
    if up
      self.comment_karma = self.comment_karma + 1
    else
      self.comment_karma = self.comment_karma - 1
    end
    self.save
  end
  
  ## Processes the effects of a vote being posted to the author
  ## of a post.
  def postvote(up)
    if up
      self.link_karma = self.link_karma + 1
    else
      self.link_karma = self.link_karma - 1
    end
    self.save
  end
  
end
