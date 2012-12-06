# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  password_digest :string(255)
#  admin           :boolean
#  username        :string(255)
#  link_karma      :integer
#  comment_karma   :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "comment vote" do
    u = users(:stephen)
    assert_differences([['u.comment_karma',1],['u.link_karma',0]]) do
      u.commentvote(true)
    end
    assert_differences([['u.comment_karma',-1],['u.link_karma',0]]) do
      u.commentvote(false)
    end
  end
  
  test "post vote" do
    u = users(:stephen)
    assert_differences([['u.link_karma',1],['u.comment_karma',0]]) do
      u.postvote(true)
    end
    assert_differences([['u.link_karma',-1],['u.comment_karma',0]]) do
      u.postvote(false)
    end
  end
  
  test "total karma" do
    u = users(:stephen)
    # Stephen has initial total karma of -1.
    assert_equal u.total_karma, -1
    # Check effects of postvotes
    u.postvote(true)
    u.postvote(true)
    u.postvote(true)
    assert_equal u.total_karma, -4
    # Check effects of commentvotes
    u.commentvote(false)
    u.commentvote(false)
    assert_equal u.total_karma, -2
  end
end
