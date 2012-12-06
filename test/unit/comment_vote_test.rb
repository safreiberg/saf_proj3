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

require 'test_helper'

class CommentVoteTest < ActiveSupport::TestCase
  test "clean through destroy" do 
    # Setup. Stephen has already upvoted this comment, and he
    # was also the OP.
    comment = comments(:one)
    u = users(:stephen)
    cv = comment_votes(:one)
    # Test the clean method for cv. Expected effects:
    #   1) Stephen's comment_karma will drop by one.
    #   2) Comment's upvotes will drop by one.
    #   3) Comment's rank will drop by one.
    assert_differences([['u.comment_karma', -1],['comment.upvotes', -1], \
                        ['comment.rank', -1]]) do
      cv.destroy
      u.reload
      comment.reload
    end
  end
  
  test "clean through destroy, 2" do
    # Setup. Stephen has already downvoted this comment, which
    # was posted by Admin
    comment = comments(:three)
    u = users(:admin)
    cv = comment_votes(:three)
    # Test the clean method for cv. Expected effects:
    #   1) Admin's comment_karma will drop by one.
    #   2) Comment's upvotes will drop by one.
    #   3) Comment's rank will drop by one.
    assert_differences([['u.comment_karma', 1],['comment.upvotes', 0], \
                        ['comment.downvotes', -1],['comment.rank', 1]]) do
      cv.destroy
      u.reload
      comment.reload
    end
  end
end
