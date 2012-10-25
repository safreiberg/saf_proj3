class User < ActiveRecord::Base
  attr_accessible :admin, :email, :name, :password_digest, :username, :password_confirmation, :link_karma, :comment_karma
  has_secure_password

  validates :password, :presence => true, :on => :create
  validates :email, :presence => true
  validates :email, :uniqueness => true
  validates :username, :presence => true
  validates :username, :uniqueness => true
  
end
