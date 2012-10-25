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
  # test "the truth" do
  #   assert true
  # end
end
