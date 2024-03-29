# == Schema Information
#
# Table name: post_votes
#
#  id         :integer          not null, primary key
#  post_id    :integer
#  user_id    :integer
#  up         :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PostVote < ActiveRecord::Base
  attr_accessible :post_id, :up, :user_id
  belongs_to :post
  belongs_to :user
  
  # All fields must be present for this to be a valid Vote.
  validates_presence_of :post_id
  validates :up, :inclusion => {:in => [true, false]}
  validates_presence_of :user_id
  
  before_destroy :clean
  
  ## Removes the effects of the current PostVote, as should 
  ## occur immediately before the vote is destroyed. This 
  ## means that any up or down karma effects are reversed.
  ## Effects are:
  ##  1) Change the link_karma of the author.
  ##  2) Change the karma and rank associated with the Post
  ##     that this vote was aimed at.
  def clean
    if self.up
      self.post.user.link_karma = self.post.user.link_karma - 1
      self.post.user.save!
      self.post.upvotes = self.post.upvotes - 1
      self.post.save!
      self.post.update_rank
    else
      self.post.user.link_karma = self.post.user.link_karma + 1
      self.post.user.save!
      self.post.downvotes = self.post.downvotes - 1
      self.post.save!
      self.post.update_rank
    end
  end
end
