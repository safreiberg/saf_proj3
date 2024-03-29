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
#  upvotes    :integer
#  downvotes  :integer
#  rank       :integer
#

class Post < ActiveRecord::Base
  attr_accessible :content, :user_id, :title, :upvotes, :downvotes, :rank
  belongs_to :user
  has_many :post_votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  
  validates_presence_of :content
  validates_presence_of :user_id
  validates_numericality_of :user_id
  validates_numericality_of :upvotes
  validates_numericality_of :downvotes
  validates_numericality_of :rank
  validates_presence_of :title
  
  ## Processes the effects of a given user voting in a given way (up or down)
  ## on this Post. Actions are:
  ##  1) Delete the previous vote, if present. This also undoes any appropriate
  ##     karma changes that are necessary.
  ##  2) Create the new PostVote.
  ##  3) Update the author and this Post's karma and rank.
  def vote(user, up)
    prev_vote = self.post_votes.where(user_id: user.id).first
    if !prev_vote.nil? && prev_vote != []
      prev_vote.destroy
    end
    # Reload is necessary because prev_vote.destroy actually modifies
    # some upvotes / downvotes / rank values. If we do not reload, the following
    # lines have an outdated view of the database and do not have correct
    # logic.
    self.reload
    PostVote.create(user_id: user.id, post_id: self.id, up: up)
    if up
      self.upvotes = self.upvotes + 1
    else
      self.downvotes = self.downvotes + 1
    end
    self.save!
    self.user.postvote(up)
    self.update_rank
  end
  
  ## Updates the rank of this Post according to the formula:
  ##   rank = upvotes - downvotes
  ## This is called when new PostVotes are added.
  def update_rank
    self.rank = self.upvotes - self.downvotes
    self.save!
  end
  
end
