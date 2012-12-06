ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  fixtures :all

  # Runs assert_difference with a number of conditions and varying difference
  # counts.
  #
  # Call as follows:
  #
  #   assert_differences([['Model1.count', 2], ['Model2.count', 3]])
  #
  # http://wholemeal.co.nz/blog/2011/04/06/assert-difference-with-multiple-count-values/
  def assert_differences(expression_array, message = nil, &block)
    b = block.send(:binding)
    before = expression_array.map { |expr| eval(expr[0], b) }

    yield

    expression_array.each_with_index do |pair, i|
      e = pair[0]
      difference = pair[1]
      error = "#{e.inspect} didn't change by #{difference}"
      error = "#{message}\n#{error}" if message
      assert_equal(before[i] + difference, eval(e, b), error)
    end
  end
  
  # Sets the current_user by changing the necessary session variables.
  def set_current_user(user)
    if user.nil?
      session[:authenticated] = false
      session[:user_id] = 0
    else
      session[:authenticated] = true
      session[:user_id] = user.id
    end
  end
  
  # Gets the current_user through the session variables.
  def get_current_user
    if session[:authenticated]
      return User.find_by_id(session[:user_id])
    end
    return nil
  end
end
