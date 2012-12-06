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

require 'test_helper'

class PostVoteTest < ActiveSupport::TestCase
  test "clean through destroy" do 
    # Setup. Stephen has already upvoted this comment, and
    # he was also the OP.
    post = posts(:one)
    u = users(:stephen)
    cv = post_votes(:one)
    # Test the clean method for cv. Expected effects:
    #   1) Stephen's link_karma will drop by one.
    #   2) Post's upvotes will drop by one.
    #   3) Post's rank will drop by one.
    assert_differences([['u.link_karma', -1],['post.upvotes', -1], \
                        ['post.rank', -1]]) do
      cv.destroy
      u.reload
      post.reload
    end
  end
  
  test "clean through destroy, 2" do
    # Setup. Stephen has already downvoted this post, which
    # was posted by Admin
    post = posts(:three)
    u = users(:admin)
    cv = post_votes(:three)
    # Test the clean method for cv. Expected effects:
    #   1) Admin's link_karma will drop by one.
    #   2) Post's upvotes will drop by one.
    #   3) Post's rank will drop by one.
    assert_differences([['u.link_karma', 1],['post.upvotes', 0], \
                        ['post.downvotes', -1],['post.rank', 1]]) do
      cv.destroy
      u.reload
      post.reload
    end
  end
  
end
