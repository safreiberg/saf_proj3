# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  post_id    :integer
#  user_id    :integer
#  content    :text
#  parent     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  rank       :integer
#  downvotes  :integer
#  upvotes    :integer
#

class Comment < ActiveRecord::Base
  attr_accessible :content, :parent, :post_id, :user_id, :upvotes, :downvotes, :rank
  belongs_to :post
  belongs_to :user
  has_many :comment_votes
  
  ## Processes the effects of a given user voting in a given way (up or down)
  ## on this Comment. Actions are:
  ##  1) Delete the previous vote, if present. This also undoes any appropriate
  ##     karma changes that are necessary.
  ##  2) Create the new CommentVote.
  ##  3) Update the author and this Comment's karma.
  def vote(user, up)
    prev_vote = self.comment_votes.where(user_id: user.id).first
    if !prev_vote.nil? && prev_vote != []
      prev_vote.destroy
    end
    self.reload
    CommentVote.create(user_id: user.id, comment_id: self.id, up: up)
    if up
      self.upvotes = self.upvotes + 1
    else
      self.downvotes = self.downvotes + 1
    end
    self.save!
    self.user.commentvote(up)
    self.update_rank
  end
  
  ## Updates the rank of this Comment according to the formula:
  ##   rank = upvotes - downvotes
  ## This is called when new CommentVotes are added.
  def update_rank
    self.rank = self.upvotes - self.downvotes
    self.save
  end
end
