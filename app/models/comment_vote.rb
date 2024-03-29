# == Schema Information
#
# Table name: comment_votes
#
#  id         :integer          not null, primary key
#  comment_id :integer
#  user_id    :integer
#  up         :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CommentVote < ActiveRecord::Base
  attr_accessible :comment_id, :up, :user_id
  belongs_to :comment
  belongs_to :user
  
  # All fields must be present for this to be a valid Vote.
  validates_presence_of :comment_id
  validates :up, :inclusion => {:in => [true, false]}
  validates_presence_of :user_id
  validates_numericality_of :user_id
  validates_numericality_of :comment_id
  
  before_destroy :clean
  
  ## Removes the effects of the current CommentVote, as should 
  ## occur immediately before the vote is destroyed. This 
  ## means that any up or down karma effects are reversed.
  ## Effects are:
  ##  1) Change the comment_karma of the author.
  ##  2) Change the karma and rank associated with the Comment
  ##     that this vote was aimed at. 
  def clean
    if self.up
      self.comment.user.comment_karma = self.comment.user.comment_karma - 1
      self.comment.user.save
      self.comment.upvotes = self.comment.upvotes - 1
      self.comment.save
      self.comment.update_rank
    else
      self.comment.user.comment_karma = self.comment.user.comment_karma + 1
      self.comment.user.save
      self.comment.downvotes = self.comment.downvotes - 1
      self.comment.save
      self.comment.update_rank
    end
  end
  
end
