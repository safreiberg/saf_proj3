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
  attr_accessible :admin, :email, :name, :password_digest, :username, :password_confirmation, :link_karma, :comment_karma
  has_secure_password

  validates :password, :presence => true, :on => :create
  validates :email, :presence => true
  validates :email, :uniqueness => true
  validates :username, :presence => true
  validates :username, :uniqueness => true
  
end
