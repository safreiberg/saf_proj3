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

class PostVote < ActiveRecord::Base
  attr_accessible :post_id, :up, :user_id
end
