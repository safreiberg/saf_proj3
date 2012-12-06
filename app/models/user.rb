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
  attr_accessible :admin, :email, :name, :password_digest, :password
  attr_accessible :username, :password_confirmation, :link_karma, :comment_karma
  has_secure_password
  
  has_many :comments
  has_many :posts

  validates :password, :presence => true, :on => :create
  validates :email, :presence => true
  validates :email, :uniqueness => true
  validates :username, :presence => true
  validates :username, :uniqueness => true
  validates_numericality_of :link_karma
  validates_numericality_of :comment_karma
  
  ## Processes the effects of a vote being posted to the author
  ## of a comment, assuming this user is the author.
  def commentvote(up)
    if up
      self.comment_karma = self.comment_karma + 1
    else
      self.comment_karma = self.comment_karma - 1
    end
    self.save!
  end
  
  ## Processes the effects of a vote being posted to the author
  ## of a post, assuming this user is the author.
  def postvote(up)
    if up
      self.link_karma = self.link_karma + 1
    else
      self.link_karma = self.link_karma - 1
    end
    self.save!
  end
  
  # Total karma is used for sorting the users list.
  # Since sorts are automatically from lowest to highest, and
  # is makes more sense to sort popularity from highest to 
  # lowest, this returns the *opposite* of total karma.
  def total_karma
    -1*(link_karma + comment_karma)
  end
end
