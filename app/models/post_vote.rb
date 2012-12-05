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
      self.user.link_karma = self.user.link_karma - 1
      self.user.save
      self.post.upvotes = self.post.upvotes - 1
      self.post.save
      self.post.update_rank
    else
      self.user.link_karma = self.user.link_karma + 1
      self.user.save
      self.post.upvotes = self.post.upvotes + 1
      self.post.save
      self.post.update_rank
    end
  end
end
