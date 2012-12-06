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

require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test "voting on posts" do
    post = posts(:two)
    u = users(:admin)
    op = users(:stephen)
    # First upvote.
    # Stephen should receive link karma.
    assert_differences([['post.upvotes',1],['op.link_karma',1]]) do
      post.vote(u, true)
      op.reload
    end
    # Already voted.
    assert_differences([['post.upvotes',0],['op.link_karma',0]]) do
      post.vote(u, true)
      op.reload
    end
    # Upvote changes to downvote.
    assert_differences([['post.upvotes',-1],['post.downvotes',1],\
                        ['op.link_karma',-2]]) do
      post.vote(u, false)
      op.reload
    end
    # Already downvoted.
    assert_differences([['post.upvotes',0],['post.downvotes',0],\
                        ['op.link_karma',0]]) do
      post.vote(u, false)
      op.reload
    end
  end
  
  test "update rank" do 
    post = posts(:two)
    u = users(:admin)
    # First upvote.
    assert_difference('post.rank', 1) do
      post.vote(u, true)
    end
    # Already upvoted. No change should occur.
    assert_difference('post.rank', 0) do
      post.vote(u, true)
    end
    # From +1 to -1 is a swing of -2.
    assert_difference('post.rank', -2) do
      post.vote(u, false)
    end
    # Already downvoted. No change should occur.
    assert_difference('post.rank', 0) do
      post.vote(u, false)
    end
  end
  
end
