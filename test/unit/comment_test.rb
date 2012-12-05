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
    assert_difference('comment.upvotes', 1) do
      comment.vote(u, true)
    end
  end
end
