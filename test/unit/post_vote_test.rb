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
  # test "the truth" do
  #   assert true
  # end
end
