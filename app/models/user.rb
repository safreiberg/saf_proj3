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

class User < ActiveRecord::Base
  attr_accessible :admin, :email, :name, :password_digest, :password
  attr_accessible :username, :password_confirmation, :link_karma, :comment_karma
  has_secure_password
  
  has_many :comments
  has_many :posts

  validates :password, :presence => true, :on => :create
  validates :email, :presence => true
  validates :email, :uniqueness => true
  validates :username, :presence => true
  validates :username, :uniqueness => true
  validates_numericality_of :link_karma
  validates_numericality_of :comment_karma
  
  ## Processes the effects of a vote being posted to the author
  ## of a comment, assuming this user is the author.
  def commentvote(up)
    if up
      self.comment_karma = self.comment_karma + 1
    else
      self.comment_karma = self.comment_karma - 1
    end
    self.save!
  end
  
  ## Processes the effects of a vote being posted to the author
  ## of a post, assuming this user is the author.
  def postvote(up)
    if up
      self.link_karma = self.link_karma + 1
    else
      self.link_karma = self.link_karma - 1
    end
    self.save!
  end
  
  # Total karma is used for sorting the users list.
  # Since sorts are automatically from lowest to highest, and
  # is makes more sense to sort popularity from highest to 
  # lowest, this returns the *opposite* of total karma.
  def total_karma
    -1*(link_karma + comment_karma)
  end
  
  # Get the rank of this user based on his link_karma score.
  # The rank is calculated by sorting all of the users based on
  # their link_karma score from highest to lowest.
  #
  # In order to prevent this request from being O(n) on every
  # call, the ordering is cached in a file on the server.
  # The cache is determined to be 'stale' (in need of recompu-
  # tation) iff good_time_to_update returns true.
  def link_karma_rank
    # Update the file if necessary
    if self.good_time_to_update || !File.exist?('tmp/link_karma.txt')
      users_link = User.find(:all).sort! {|u| -1*u.link_karma}
      File.open('tmp/link_karma.txt', 'w') {|f| users_link.each { |u| f.puts(u.inspect) } }
    end
    # Find this user and return
    f = File.open("tmp/link_karma.txt", 'r')
    r = 1
    begin
      while true
        if self.inspect.strip() == f.readline.strip()
          return r
        else
          r = r + 1
        end
      end
    rescue EOFError
      # User was not in the file, thus is ranked last.
      return r
    end
  end
  
  # Get the rank of this user based on his comment_karma score.
  # The rank is calculated by sorting all of the users based on
  # their comment_karma score from highest to lowest.
  #
  # In order to prevent this request from being O(n) on every
  # call, the ordering is cached in a file on the server.
  # The cache is determined to be 'stale' (in need of recompu-
  # tation) iff good_time_to_update returns true.
  def comment_karma_rank
    # Update the file if necessary
    if self.good_time_to_update || !File.exist?('tmp/comment_karma.txt')
      users_comment = User.find(:all).sort! {|u| -1*u.comment_karma}
      File.open('tmp/comment_karma.txt', 'w') {|f| users_comment.each { |u| f.puts(u.inspect) } }
    end
    # Find this user and return
    f = File.open("tmp/comment_karma.txt", 'r')
    r = 1
    begin
      while true
        if self.inspect.strip() == f.readline.strip()
          return r
        else
          r = r + 1
        end
      end
    rescue EOFError
      # User was not in the file, thus is ranked last.
      return r
    end
  end
  
  # Get the rank of this user based on his total karma score.
  # The rank is calculated by sorting all of the users based on
  # their (link_karma + comment_karma) score from highest to lowest.
  #
  # In order to prevent this request from being O(n) on every
  # call, the ordering is cached in a file on the server.
  # The cache is determined to be 'stale' (in need of recompu-
  # tation) iff good_time_to_update returns true.
  def total_karma_rank
    # Update the file if necessary
    if self.good_time_to_update || !File.exist?('tmp/total_karma.txt')
      users_total = User.find(:all).sort_by &:total_karma
      File.open('tmp/total_karma.txt', 'w') {|f| users_total.each { |u| f.puts(u.inspect) } }
    end
    # Find this user and return
    f = File.open("tmp/total_karma.txt", 'r')
    r = 1
    begin
      while true
        if self.inspect.strip() == f.readline.strip()
          return r
        else
          r = r + 1
        end
      end
    rescue EOFError
      # User was not in the file, thus is ranked last.
      return r
    end
  end
  
  # Returns true when the cached information about karma ranks
  # is stale, else false.
  #
  # This function will be used to throttle the number of
  # operations required by requesting ranks in the amortized
  # case. Since recomputation of the total ranks is O(n) for 
  # n ::= number of users, this recomputation could be very
  # expensive if performed many times.
  #
  # Because of the current scale of this project, this function
  # always returns true. If, in the future, scalability becomes
  # an issue, this can be throttled by time limits or frequency
  # of calls limits.
  def good_time_to_update
    true
  end
  
end
