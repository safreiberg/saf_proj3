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

require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  test "voting on comments" do
    comment = comments(:two)
    u = users(:admin)
    # First upvote.
    assert_difference('comment.upvotes', 1) do
      comment.vote(u, true)
    end
    # Already voted.
    assert_difference('comment.upvotes', 0) do
      comment.vote(u, true)
    end
    # Upvote changes to downvote.
    assert_differences([['comment.upvotes', -1], ['comment.downvotes', 1]]) do
      comment.vote(u, false)
    end
    # Already downvoted.
    assert_differences([['comment.upvotes', 0], ['comment.downvotes', 0]]) do
      comment.vote(u, false)
    end
  end
  
  test "update rank" do 
    comment = comments(:two)
    u = users(:admin)
    # First upvote.
    assert_difference('comment.rank', 1) do
      comment.vote(u, true)
    end
    # Already upvoted. No change should occur.
    assert_difference('comment.rank', 0) do
      comment.vote(u, true)
    end
    # From +1 to -1 is a swing of -2.
    assert_difference('comment.rank', -2) do
      comment.vote(u, false)
    end
    # Already downvoted. No change should occur.
    assert_difference('comment.rank', 0) do
      comment.vote(u, false)
    end
  end
end
